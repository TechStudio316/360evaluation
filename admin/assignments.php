<?php
require __DIR__.'/../includes/core.php';
require_login(['admin']);
$error='';$preview=[];$previewWarnings=[];
$modules=all("SELECT * FROM modules WHERE is_active=1 AND evaluator_role!='public' AND slug NOT IN ('personal-evaluation','self-evaluation') ORDER BY name");
$peer=one("SELECT * FROM modules WHERE slug='peer-observation' AND evaluator_role='teacher' AND is_active=1");
$users=all('SELECT u.*,s.name section_name FROM users u LEFT JOIN school_sections s ON s.id=u.section_id WHERE u.is_active=1 ORDER BY s.name,u.name,u.id');
$cycles=all('SELECT c.*,s.name session_name FROM evaluation_cycles c JOIN academic_sessions s ON s.id=c.session_id WHERE c.is_open=1 ORDER BY c.id DESC');
function build_pairs(array $users):array {
    $groups=[];$warnings=[];$pairs=[];
    foreach($users as $u){if($u['role']==='teacher' && $u['section_id']!==null){$groups[(int)$u['section_id']]['name']=$u['section_name'];$groups[(int)$u['section_id']]['teachers'][]=$u;}}
    foreach($groups as $section=>$group){$members=$group['teachers'];$count=count($members);
        if($count<2){$warnings[]=$group['name'].': only one eligible teacher; no pairing created.';continue;}
        // A shuffled circular assignment is a bijection with no self-pairings.
        shuffle($members);
        for($i=0;$i<$count;$i++){$pairs[]=['section'=>$group['name'],'evaluator'=>$members[$i],'subject'=>$members[($i+1)%$count]];}
    }
    $unassigned=array_filter($users,fn($u)=>$u['role']==='teacher' && $u['section_id']===null);
    if($unassigned)$warnings[]=count($unassigned).' teacher(s) without a school section were skipped.';
    if(!$pairs)$warnings[]='No eligible sections with two or more active teachers.';
    return [$pairs,$warnings];
}
if($_SERVER['REQUEST_METHOD']==='POST'){
 verify_csrf();$action=$_POST['action']??'manual';
 try {
  if($action==='manual'){
   $m=one('SELECT * FROM modules WHERE id=? AND is_active=1',[(int)($_POST['module_id']??0)]);
   $ev=one('SELECT * FROM users WHERE id=? AND is_active=1',[(int)($_POST['evaluator_id']??0)]);
   $sub=one("SELECT * FROM users WHERE id=? AND role='teacher' AND is_active=1",[(int)($_POST['subject_id']??0)]);
   $cycle=one('SELECT * FROM evaluation_cycles WHERE id=? AND is_open=1',[(int)($_POST['cycle_id']??0)]);
   if(!$m||!$ev||!$sub||!$cycle||$m['evaluator_role']==='public'||($m['evaluator_role']!=='admin'&&$m['evaluator_role']!==$ev['role'])||(is_self_module($m['slug']) ? $ev['id']!==$sub['id'] : $ev['id']===$sub['id']))throw new Exception('Invalid module, evaluator, teacher or cycle.');
   if(is_self_module($m['slug']) && $ev['role']!=='teacher')throw new Exception('Only teachers can complete self-evaluation.');
   if($m['slug']==='peer-observation' && ($ev['role']!=='teacher'||$ev['section_id']===null||$sub['section_id']===null||(int)$ev['section_id']!==(int)$sub['section_id']))throw new Exception('Peer observers and observed teachers must belong to the same school section.');
   sql('INSERT INTO assignments(module_id,cycle_id,evaluator_id,subject_id) VALUES (?,?,?,?)',[$m['id'],$cycle['id'],$ev['id'],$sub['id']]);
   audit('assignment_created',(string)db()->lastInsertId());flash('Manual evaluation assignment created.');go('admin/assignments.php');
  } elseif($action==='preview_auto'||$action==='save_auto'){
   if(!$peer)throw new Exception('Activate the Peer Observation module first.');
   $cycle=one('SELECT * FROM evaluation_cycles WHERE id=? AND is_open=1',[(int)($_POST['cycle_id']??0)]);
   if(!$cycle)throw new Exception('Choose an open evaluation cycle.');
   if($action==='preview_auto'){
     [$preview,$previewWarnings]=build_pairs($users);
     // Save exact proposed pair IDs in the admin session, so confirmation saves the previewed matches.
     $_SESSION['auto_pair_preview']=['cycle'=>(int)$cycle['id'],'module'=>(int)$peer['id'],'pairs'=>array_map(fn($p)=>[(int)$p['evaluator']['id'],(int)$p['subject']['id']],$preview)];
   }else{
     $saved=$_SESSION['auto_pair_preview']??null;
     if(!$saved||(int)$saved['cycle']!==(int)$cycle['id']||(int)$saved['module']!==(int)$peer['id'])throw new Exception('Preview the automatic pairs before confirming.');
     if(empty($saved['pairs']))throw new Exception('No valid pairs were generated.');
     $created=0;$skipped=0;$pdo=db();$pdo->beginTransaction();
     try{
       foreach($saved['pairs'] as [$e,$s]){
         // Revalidate every match at save time, including section membership and active status.
         $valid=one("SELECT e.id FROM users e JOIN users t ON t.id=? WHERE e.id=? AND e.role='teacher' AND t.role='teacher' AND e.is_active=1 AND t.is_active=1 AND e.section_id IS NOT NULL AND e.section_id=t.section_id AND e.id<>t.id",[$s,$e]);
         if(!$valid){$skipped++;continue;}
         $existing=one('SELECT id FROM assignments WHERE module_id=? AND cycle_id=? AND evaluator_id=? AND subject_id=?',[$peer['id'],$cycle['id'],$e,$s]);
         if($existing){$skipped++;continue;}
         sql('INSERT INTO assignments(module_id,cycle_id,evaluator_id,subject_id) VALUES (?,?,?,?)',[$peer['id'],$cycle['id'],$e,$s]);$created++;
       }
       audit('automatic_peer_pairing','cycle='.$cycle['id'].' created='.$created.' skipped='.$skipped);
       $pdo->commit();unset($_SESSION['auto_pair_preview']);
       flash("Automatic pairing completed: $created assignment(s) created; $skipped skipped (existing or ineligible).");go('admin/assignments.php');
     }catch(Throwable $e){if($pdo->inTransaction())$pdo->rollBack();throw $e;}
   }
  }else throw new Exception('Unknown action.');
 }catch(Throwable $e){$error=$e->getMessage();}
}
$assign=all('SELECT a.*,m.name module_name,u.name evaluator,t.name teacher,s.name session_name,c.term,ss.name section_name FROM assignments a JOIN modules m ON m.id=a.module_id JOIN users u ON u.id=a.evaluator_id JOIN users t ON t.id=a.subject_id LEFT JOIN school_sections ss ON ss.id=t.section_id JOIN evaluation_cycles c ON c.id=a.cycle_id JOIN academic_sessions s ON s.id=c.session_id ORDER BY a.id DESC LIMIT 500');
ob_start();if($error)echo '<div class="alert error">'.h($error).'</div>';
?>
<div class="card"><h2>Automatic Peer Observation Pairing</h2><p class="muted">Create randomized, same-section observation assignments. Each teacher observes one colleague and is observed once. Sections with fewer than two active teachers are skipped.</p>
<?php if(!$peer): ?><div class="alert error">Peer Observation is inactive. Activate it under Evaluation Modules to use automatic pairing.</div><?php endif; ?>
<form method="post"><?=token()?><input type="hidden" name="action" value="preview_auto"><div class="formgrid"><div><label>Academic session / term</label><select name="cycle_id" required><?php foreach($cycles as $c)echo '<option value="'.h($c['id']).'">'.h($c['session_name'].' — '.$c['term']).'</option>';?></select></div></div><p><button type="submit" <?=(!$peer||!$cycles)?'disabled':''?>>Generate pairing preview</button></p></form>
<?php if($preview): ?><h3>Preview — <?=count($preview)?> proposed assignments</h3><div class="tablewrap"><table><thead><tr><th>School Section</th><th>Observer</th><th>Teacher Observed</th></tr></thead><tbody><?php foreach($preview as $p): ?><tr><td><?=h($p['section'])?></td><td><?=h($p['evaluator']['name'])?></td><td><?=h($p['subject']['name'])?></td></tr><?php endforeach;?></tbody></table></div>
<?php foreach($previewWarnings as $warning): ?><p class="muted"><?=h($warning)?></p><?php endforeach; ?>
<form method="post" onsubmit="return confirm('Save these peer observation assignments? Existing assignments will not be overwritten.');"><?=token()?><input type="hidden" name="action" value="save_auto"><input type="hidden" name="cycle_id" value="<?=h($_SESSION['auto_pair_preview']['cycle'])?>"><p><button type="submit">Confirm and save these pairs</button></p></form>
<?php elseif($previewWarnings): foreach($previewWarnings as $warning): ?><p class="muted"><?=h($warning)?></p><?php endforeach;endif; ?>
</div>
<div class="card"><h2>Personal / Self-Evaluation — Automatic Access</h2><p class="muted">All active teachers automatically receive their own Personal Evaluation for each open academic cycle when they access their teacher dashboard. No manual assignment or bulk assignment is needed. Peer Observation pairing remains independent.</p></div>
<div class="card"><h2>Manual Evaluation Assignment</h2><p class="muted">For Peer Observation, the observer and teacher must belong to the same section. Other modules retain their configured evaluator roles.</p>
<form method="post"><?=token()?><input type="hidden" name="action" value="manual"><div class="formgrid"><div><label>Module</label><select name="module_id" required><?php foreach($modules as $m)echo '<option value="'.h($m['id']).'">'.h($m['name'].' ('.$m['evaluator_role'].')').'</option>';?></select></div><div><label>Cycle</label><select name="cycle_id" required><?php foreach($cycles as $c)echo '<option value="'.h($c['id']).'">'.h($c['session_name'].' '.$c['term']).'</option>';?></select></div><div><label>Evaluator</label><select name="evaluator_id" required><?php foreach($users as $u)echo '<option value="'.h($u['id']).'">'.h($u['name'].' — '.$u['role'].' — '.($u['section_name']??'No section')).'</option>';?></select></div><div><label>Teacher being evaluated</label><select name="subject_id" required><?php foreach($users as $u)if($u['role']==='teacher')echo '<option value="'.h($u['id']).'">'.h($u['name'].' — '.($u['section_name']??'No section')).'</option>';?></select></div></div><p><button type="submit">Create manual assignment</button></p></form></div>
<div class="card"><h2>Assigned Evaluations</h2><div class="tablewrap"><table><thead><tr><th>Module</th><th>Teacher</th><th>Evaluator</th><th>Section</th><th>Cycle</th><th>Status</th></tr></thead><tbody><?php foreach($assign as $a): ?><tr><td><?=h($a['module_name'])?></td><td><?=h($a['teacher'])?></td><td><?=h($a['evaluator'])?></td><td><?=h($a['section_name']??'—')?></td><td><?=h($a['session_name'].' '.$a['term'])?></td><td><?=h($a['status'])?></td></tr><?php endforeach; ?></tbody></table></div></div>
<?php layout('Evaluation assignments',ob_get_clean());
