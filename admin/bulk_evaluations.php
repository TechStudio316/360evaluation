<?php
require __DIR__.'/../includes/core.php';require_login(['admin']);
$error='';$cycles=all('SELECT c.id,c.term,s.name session_name FROM evaluation_cycles c JOIN academic_sessions s ON s.id=c.session_id ORDER BY c.id DESC');$modules=all('SELECT id,name FROM modules ORDER BY id');
$cycle=(int)($_REQUEST['cycle_id']??0);$module=(int)($_REQUEST['module_id']??0);
if(!$cycle&&$cycles)$cycle=(int)$cycles[0]['id'];
$where="a.cycle_id=? AND a.status='submitted'";$args=[$cycle];if($module){$where.=' AND a.module_id=?';$args[]=$module;}
$rows=$cycle?all("SELECT a.*,m.name module_name FROM assignments a JOIN modules m ON m.id=a.module_id WHERE $where ORDER BY a.id",$args):[];
if($_SERVER['REQUEST_METHOD']==='POST'){
 verify_csrf();try{
  $action=(string)($_POST['action']??'');$word=$action==='bulk_reset'?'RESET ALL':'DELETE ALL';
  if(!in_array($action,['bulk_reset','bulk_delete'],true))throw new Exception('Invalid action.');
  if(!$cycle||!$rows)throw new Exception('No submitted evaluations match the selected scope.');
  if(empty($_POST['report_saved'])||empty($_POST['backup_saved'])||($_POST['confirm_word']??'')!==$word)throw new Exception('Confirm the reports and database backup, and type '.$word.'.');
  $db=db();$db->beginTransaction();try{
   // Lock matching rows so the affected set cannot change during the operation.
   $locked=all("SELECT a.*,m.name module_name FROM assignments a JOIN modules m ON m.id=a.module_id WHERE $where FOR UPDATE",$args);
   if(count($locked)!==(int)($_POST['expected_count']??-1))throw new Exception('The number of submitted evaluations has changed. Review the scope again.');
   foreach($locked as $a){$id=(int)$a['id'];$snapshot=['action'=>$action,'assignment'=>$a,'responses'=>all('SELECT * FROM responses WHERE assignment_id=?',[$id]),'comments'=>all('SELECT * FROM evaluation_comments WHERE assignment_id=?',[$id]),'external_remarks'=>all('SELECT * FROM evaluation_external_remarks WHERE assignment_id=?',[$id]),'bulk_remarks'=>all('SELECT * FROM evaluation_bulk_remarks WHERE assignment_id=?',[$id])];
    sql('INSERT INTO evaluation_deletion_archive(assignment_id,teacher_id,module_name,deleted_by,snapshot_json) VALUES (?,?,?,?,?)',[$id,$a['subject_id'],$a['module_name'],me()['id'],json_encode($snapshot,JSON_THROW_ON_ERROR)]);
    sql('UPDATE evaluation_external_shares SET revoked_at=NOW() WHERE assignment_id=? AND revoked_at IS NULL',[$id]);
    sql('DELETE FROM responses WHERE assignment_id=?',[$id]);sql('DELETE FROM evaluation_comments WHERE assignment_id=?',[$id]);
    if($action==='bulk_reset')sql("UPDATE assignments SET status='pending',submitted_at=NULL,observation_date=NULL,subject_name=NULL,class_name=NULL,period_name=NULL WHERE id=?",[$id]);
    else sql('DELETE FROM assignments WHERE id=?',[$id]);
   }
   // A general review link covering the affected cycle must not continue showing an altered report set.
   sql('UPDATE evaluation_bulk_shares SET revoked_at=NOW() WHERE revoked_at IS NULL AND (cycle_id IS NULL OR cycle_id=?) AND (module_id IS NULL OR module_id=?)',[$cycle,$module]);
   audit($action,'Cycle '.$cycle.' module '.$module.' count '.count($locked));$db->commit();
  }catch(Throwable $e){if($db->inTransaction())$db->rollBack();throw $e;}
  flash(count($locked).' evaluations processed. Archived snapshots retained.');go('admin/bulk_evaluations.php?cycle_id='.$cycle.'&module_id='.$module);
 }catch(Throwable $e){$error=$e->getMessage();}
}
ob_start();?>
<div class="card"><h2>Bulk reset / delete submitted evaluations</h2><p><strong>Danger:</strong> These actions affect every submitted assessment matching the chosen cycle and module. Download individual PDF reports, export the results CSV and back up the database before proceeding. Reset reopens existing assignments; delete removes them. Historical snapshots remain in the restricted archive.</p><?php if($error):?><div class="alert error"><?=h($error)?></div><?php endif;?>
<form method="get"><label>Academic cycle</label><select name="cycle_id" required><?php foreach($cycles as $c):?><option value="<?=$c['id']?>" <?=$cycle==$c['id']?'selected':''?>><?=h($c['session_name'].' '.$c['term'])?></option><?php endforeach;?></select><label>Evaluation module</label><select name="module_id"><option value="0">All modules in this cycle</option><?php foreach($modules as $m):?><option value="<?=$m['id']?>" <?=$module==$m['id']?'selected':''?>><?=h($m['name'])?></option><?php endforeach;?></select><p><button>Preview affected evaluations</button></p></form><h3><?=count($rows)?> submitted evaluations will be affected</h3><p><a class="btn alt" href="<?=url('management/reports.php?csv=1')?>">Export submitted results CSV (all teachers)</a></p></div>
<?php if($rows):?><div class="card"><div class="tablewrap"><table><tr><th>ID</th><th>Module</th><th>PDF report</th></tr><?php foreach($rows as $a):?><tr><td><?=$a['id']?></td><td><?=h($a['module_name'])?></td><td><a href="<?=url('management/report.php?id='.$a['id'])?>" target="_blank" rel="noopener">View / Save PDF</a></td></tr><?php endforeach;?></table></div></div>
<?php foreach(['bulk_reset'=>'RESET ALL','bulk_delete'=>'DELETE ALL'] as $action=>$word):?><div class="card"><h3><?=$action==='bulk_reset'?'Reset all matching evaluations':'Delete all matching evaluations'?></h3><form method="post" onsubmit="return confirm('DANGER: This affects <?=count($rows)?> submitted evaluations. Proceed?')"><?=token()?><input type="hidden" name="action" value="<?=$action?>"><input type="hidden" name="cycle_id" value="<?=$cycle?>"><input type="hidden" name="module_id" value="<?=$module?>"><input type="hidden" name="expected_count" value="<?=count($rows)?>"><label><input type="checkbox" name="report_saved" required> I have downloaded and safely stored the PDF reports for all affected assessments</label><label><input type="checkbox" name="backup_saved" required> I have made a full database backup</label><label>Type <?=$word?> to confirm</label><input name="confirm_word" required placeholder="<?=$word?>" pattern="<?=$word?>"><p><button type="submit"><?=$word?></button></p></form></div><?php endforeach;?><?php endif;?>
<?php layout('Bulk evaluation management',ob_get_clean());
