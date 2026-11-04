<?php
require __DIR__.'/../includes/core.php';
require_login(['admin']);
$error='';

// Importable templates keyed by module slug. Counts are the minimum expected after import.
$templates=[
 'personal-evaluation'=>['file'=>'self_evaluation_module.sql','label'=>'Load 30 Self-Evaluation Criteria from SQL','sections'=>6,'criteria'=>30],
 'self-evaluation'=>['file'=>'self_evaluation_12_sections.sql','label'=>'Load 12 Self-Evaluation Sections from SQL','sections'=>12,'criteria'=>69],
];

function module_locked(int $moduleId):bool{return (int)one("SELECT COUNT(*) n FROM assignments WHERE module_id=? AND status='submitted'",[$moduleId])['n']>0;}
// Split a SQL script on statement-terminating semicolons, ignoring semicolons inside quoted strings.
function split_sql(string $sql):array{
 $sql=preg_replace('/^\s*--[^\n]*$/m','',$sql);
 $out=[];$buf='';$inStr=false;$len=strlen($sql);
 for($i=0;$i<$len;$i++){
  $ch=$sql[$i];
  if($inStr){
   $buf.=$ch;
   if($ch==="'"){if($i+1<$len&&$sql[$i+1]==="'"){$buf.=$sql[++$i];}else{$inStr=false;}}
  }elseif($ch==="'"){$inStr=true;$buf.=$ch;}
  elseif($ch===';'){$out[]=$buf;$buf='';}
  else{$buf.=$ch;}
 }
 if(trim($buf)!=='')$out[]=$buf;
 return $out;
}
// template_sections, criteria and rating_descriptions are MyISAM, so declared cascades are not enforced; delete children explicitly.
function delete_criterion(int $criterionId):void{sql('DELETE FROM rating_descriptions WHERE criterion_id=?',[$criterionId]);sql('DELETE FROM responses WHERE criterion_id=?',[$criterionId]);sql('DELETE FROM criteria WHERE id=?',[$criterionId]);}
function delete_section(int $sectionId):void{foreach(all('SELECT id FROM criteria WHERE section_id=?',[$sectionId]) as $c)delete_criterion((int)$c['id']);sql('DELETE FROM template_sections WHERE id=?',[$sectionId]);}

if($_SERVER['REQUEST_METHOD']==='POST'){
 verify_csrf();
 try{
  $action=(string)($_POST['action']??'');
  $target=isset($_POST['module_id'])?(int)$_POST['module_id']:0;
  $editing=['section','criterion','description','section_update','section_delete','criterion_update','criterion_delete'];
  if(in_array($action,$editing,true) && $target && module_locked($target))throw new Exception('This module has submitted evaluations and is locked. Create a new module for revised criteria.');
  if($action==='load_template'){
   $selected=one('SELECT id,name,slug FROM modules WHERE id=?',[$target]);
   if(!$selected||!isset($templates[$selected['slug']]))throw new Exception('No importable template is available for this module.');
   if(module_locked($target))throw new Exception('This module has submitted evaluations and is locked.');
   $spec=$templates[$selected['slug']];
   $seed=@file_get_contents(__DIR__.'/../database/'.$spec['file']);
   if($seed===false)throw new Exception('Template SQL file not found.');
   // MyISAM tables ignore transaction rollback; the seeds are idempotent, so a retry safely completes a partial import.
   $pdo=db();
   foreach(split_sql($seed) as $statement){
    $statement=trim($statement);
    if($statement===''||$statement==='START TRANSACTION'||$statement==='COMMIT')continue;
    if(stripos($statement,'SELECT')===0){$pdo->query($statement)->fetchAll();continue;}
    $pdo->exec($statement);
   }
   $sections=(int)one('SELECT COUNT(*) n FROM template_sections WHERE module_id=?',[$target])['n'];
   $indicators=(int)one('SELECT COUNT(*) n FROM criteria c JOIN template_sections s ON s.id=c.section_id WHERE s.module_id=?',[$target])['n'];
   if($sections<$spec['sections']||$indicators<$spec['criteria'])throw new Exception('Template load incomplete. Retry to finish importing missing indicators.');
   audit('module_configuration','load_template:'.$selected['slug']);
   flash($selected['name'].' template loaded: '.$indicators.' indicators across '.$sections.' sections.');
   go('admin/modules.php?id='.$target);
  }
  if($action==='new'){
   $name=trim($_POST['name']);$slug=strtolower(trim(preg_replace('/[^a-z0-9]+/','-',strtolower($name)),'-'));
   if(!$name||!$slug)throw new Exception('Enter a module name.');
   sql('INSERT INTO modules(name,slug,evaluator_role,rating_direction,is_active) VALUES (?,?,?,?,0)',[$name,$slug,$_POST['evaluator_role'],$_POST['rating_direction']]);
   $id=db()->lastInsertId();
   $labels=($_POST['rating_direction']==='low')?['Outstanding','Good','Satisfactory','Unsatisfactory']:['Poor','Unsatisfactory','Satisfactory','Very Satisfactory','Outstanding'];
   foreach($labels as $i=>$label)sql('INSERT INTO rating_options(module_id,rating,label) VALUES (?,?,?)',[$id,$i+1,$label]);
  }elseif($action==='toggle'){
   sql('UPDATE modules SET is_active=1-is_active WHERE id=?',[(int)$_POST['id']]);
  }elseif($action==='section'){
   sql('INSERT INTO template_sections(module_id,title,weight,sort_order) VALUES (?,?,?,?)',[$target,trim($_POST['title']),(float)$_POST['weight'],(int)$_POST['sort_order']]);
  }elseif($action==='section_update'){
   $sid=(int)($_POST['section_id']??0);
   $own=one('SELECT module_id FROM template_sections WHERE id=?',[$sid]);
   if(!$own||(int)$own['module_id']!==$target)throw new Exception('Section not found in this module.');
   sql('UPDATE template_sections SET title=?,weight=?,sort_order=? WHERE id=?',[trim($_POST['title']),(float)$_POST['weight'],(int)$_POST['sort_order'],$sid]);
  }elseif($action==='section_delete'){
   $sid=(int)($_POST['section_id']??0);
   $own=one('SELECT module_id FROM template_sections WHERE id=?',[$sid]);
   if(!$own||(int)$own['module_id']!==$target)throw new Exception('Section not found in this module.');
   delete_section($sid);
  }elseif($action==='criterion'){
   $sec=one('SELECT module_id FROM template_sections WHERE id=?',[(int)$_POST['section_id']]);
   if(!$sec||(int)$sec['module_id']!==$target)throw new Exception('Section not found in this module.');
   sql('INSERT INTO criteria(section_id,title,sort_order) VALUES (?,?,?)',[(int)$_POST['section_id'],trim($_POST['title']),(int)$_POST['sort_order']]);
  }elseif($action==='criterion_update'){
   $cid=(int)($_POST['criterion_id']??0);
   $own=one('SELECT s.module_id FROM criteria c JOIN template_sections s ON s.id=c.section_id WHERE c.id=?',[$cid]);
   if(!$own||(int)$own['module_id']!==$target)throw new Exception('Indicator not found in this module.');
   sql('UPDATE criteria SET title=?,sort_order=? WHERE id=?',[trim($_POST['title']),(int)$_POST['sort_order'],$cid]);
  }elseif($action==='criterion_delete'){
   $cid=(int)($_POST['criterion_id']??0);
   $own=one('SELECT s.module_id FROM criteria c JOIN template_sections s ON s.id=c.section_id WHERE c.id=?',[$cid]);
   if(!$own||(int)$own['module_id']!==$target)throw new Exception('Indicator not found in this module.');
   delete_criterion($cid);
  }elseif($action==='description'){
   sql('INSERT INTO rating_descriptions(criterion_id,rating,description) VALUES (?,?,?) ON DUPLICATE KEY UPDATE description=VALUES(description)',[(int)$_POST['criterion_id'],(int)$_POST['rating'],trim($_POST['description'])]);
  }
  audit('module_configuration',$action);
  flash('Module configuration saved.');
  go('admin/modules.php'.($target?'?id='.$target:''));
 }catch(Throwable $e){$error=$e->getMessage();}
}
$modules=all('SELECT * FROM modules ORDER BY id');
$id=(int)($_GET['id']??0);
$module=$id?one('SELECT * FROM modules WHERE id=?',[$id]):null;
$sections=$module?all('SELECT * FROM template_sections WHERE module_id=? ORDER BY sort_order,id',[$id]):[];
$opts=$module?all('SELECT * FROM rating_options WHERE module_id=? ORDER BY rating',[$id]):[];
$locked=$module?module_locked($id):false;
ob_start();
if($error)echo '<div class="alert error">'.h($error).'</div>';
?>
<div class="card"><h2>Evaluation modules</h2><div class="tablewrap"><table><tr><th>Module</th><th>Evaluator</th><th>Status</th><th>Actions</th></tr><?php foreach($modules as $m){echo '<tr><td>'.h($m['name']).'</td><td>'.h($m['evaluator_role']).'</td><td>'.($m['is_active']?'Active':'Inactive').'</td><td><a class="btn alt" href="?id='.$m['id'].'">Configure</a> <form method="post" style="display:inline">'.token().'<input type="hidden" name="action" value="toggle"><input type="hidden" name="id" value="'.$m['id'].'"><button>'.($m['is_active']?'Deactivate':'Activate').'</button></form></td></tr>';}?></table></div></div>
<div class="card"><h2>Create evaluation module</h2><form method="post"><?=token()?><input type="hidden" name="action" value="new"><div class="formgrid"><div><label>Module name</label><input name="name" required></div><div><label>Evaluator role</label><select name="evaluator_role"><option>teacher</option><option>supervisor</option><option>management</option><option>admin</option><option>public</option></select></div><div><label>Best rating</label><select name="rating_direction"><option value="high">Highest number is best</option><option value="low">Lowest number is best</option></select></div></div><p><button>Create inactive module</button></p></form></div>
<?php if($module){?>
<div class="card"><h2>Configure: <?=h($module['name'])?></h2>
<p class="muted">Sections and indicators can be added, edited or deleted here. A module that already has submitted evaluations is locked to protect stored results; create a new module for a revised version.</p>
<?php if($locked):?><div class="alert error">This module has submitted evaluations. Adding, editing or deleting criteria is disabled.</div><?php endif;?>
<?php if(isset($templates[$module['slug']])):?><form method="post" onsubmit="return confirm('Load the full Self-Evaluation template into this module? Existing indicators are preserved and duplicates are not created.')"><?=token()?><input type="hidden" name="action" value="load_template"><input type="hidden" name="module_id" value="<?=$id?>"><p><button type="submit" <?=$locked?'disabled':''?>><?=h($templates[$module['slug']]['label'])?></button></p></form><?php endif;?>
<h3>Add section</h3><form method="post"><?=token()?><input type="hidden" name="action" value="section"><input type="hidden" name="module_id" value="<?=$id?>"><div class="formgrid"><div><label>Section title</label><input name="title" required></div><div><label>Weight % (0 for unweighted)</label><input type="number" name="weight" step="0.01" value="0"></div><div><label>Order</label><input type="number" name="sort_order" value="0"></div></div><p><button <?=$locked?'disabled':''?>>Add section</button></p></form>
<?php foreach($sections as $s){$crit=all('SELECT * FROM criteria WHERE section_id=? ORDER BY sort_order,id',[$s['id']]);?>
<hr><h3><?=h($s['title'])?> — <?=h($s['weight'])?>%</h3>
<details><summary>Edit / delete this section</summary>
<form method="post"><?=token()?><input type="hidden" name="action" value="section_update"><input type="hidden" name="module_id" value="<?=$id?>"><input type="hidden" name="section_id" value="<?=$s['id']?>"><div class="formgrid"><div><label>Section title</label><input name="title" value="<?=h($s['title'])?>" required></div><div><label>Weight %</label><input type="number" name="weight" step="0.01" value="<?=h($s['weight'])?>"></div><div><label>Order</label><input type="number" name="sort_order" value="<?=h($s['sort_order'])?>"></div></div><p><button <?=$locked?'disabled':''?>>Save section</button></p></form>
<form method="post" onsubmit="return confirm('Delete this section, all of its indicators and their rating descriptions? This cannot be undone.')"><?=token()?><input type="hidden" name="action" value="section_delete"><input type="hidden" name="module_id" value="<?=$id?>"><input type="hidden" name="section_id" value="<?=$s['id']?>"><p><button class="btn alt" <?=$locked?'disabled':''?>>Delete section</button></p></form>
</details>
<?php foreach($crit as $c){echo '<details><summary>'.h($c['title']).'</summary>';
echo '<form method="post">'.token().'<input type="hidden" name="action" value="criterion_update"><input type="hidden" name="module_id" value="'.$id.'"><input type="hidden" name="criterion_id" value="'.$c['id'].'"><label>Indicator text</label><textarea name="title" rows="2" required>'.h($c['title']).'</textarea><label>Order</label><input type="number" name="sort_order" value="'.h($c['sort_order']).'"><p><button '.($locked?'disabled':'').'>Save indicator</button></p></form>';
echo '<form method="post" onsubmit="return confirm(\'Delete this indicator and its rating descriptions? This cannot be undone.\')">'.token().'<input type="hidden" name="action" value="criterion_delete"><input type="hidden" name="module_id" value="'.$id.'"><input type="hidden" name="criterion_id" value="'.$c['id'].'"><p><button class="btn alt" '.($locked?'disabled':'').'>Delete indicator</button></p></form>';
foreach($opts as $o){$d=one('SELECT description FROM rating_descriptions WHERE criterion_id=? AND rating=?',[$c['id'],$o['rating']]);echo '<form method="post">'.token().'<input type="hidden" name="action" value="description"><input type="hidden" name="module_id" value="'.$id.'"><input type="hidden" name="criterion_id" value="'.$c['id'].'"><input type="hidden" name="rating" value="'.$o['rating'].'"><label>'.h($o['rating'].' — '.$o['label']).'</label><textarea name="description" rows="2">'.h($d['description']??'').'</textarea><button '.($locked?'disabled':'').'>Save description</button></form>';}
echo '</details>';}
echo '<form method="post">'.token().'<input type="hidden" name="action" value="criterion"><input type="hidden" name="module_id" value="'.$id.'"><input type="hidden" name="section_id" value="'.$s['id'].'"><label>Add indicator</label><input name="title" required placeholder="Criterion / measurement variable"><label>Order</label><input type="number" name="sort_order" value="'.(count($crit)+1).'"><p><button '.($locked?'disabled':'').'>Add indicator</button></p></form>';
}?>
</div>
<?php }?>
<?php layout('Evaluation module manager',ob_get_clean());
