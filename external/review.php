<?php
require __DIR__.'/../includes/core.php';
header('Referrer-Policy: no-referrer');header('X-Robots-Tag: noindex, nofollow');header('Cache-Control: no-store, private');
$token=(string)($_GET['token']??$_POST['token']??'');
if(!preg_match('/^[a-f0-9]{64}$/D',$token)){http_response_code(404);exit('Review link not found.');}
$share=one("SELECT * FROM evaluation_external_shares WHERE token_hash=? AND revoked_at IS NULL AND expires_at>NOW()",[hash('sha256',$token)]);
if(!$share){http_response_code(404);exit('This review link has expired or been revoked.');}
$id=(int)$share['assignment_id'];
$a=one("SELECT a.*,m.name module_name,t.name teacher,s.name session_name,c.term FROM assignments a JOIN modules m ON m.id=a.module_id JOIN users t ON t.id=a.subject_id JOIN evaluation_cycles c ON c.id=a.cycle_id JOIN academic_sessions s ON s.id=c.session_id WHERE a.id=? AND a.status='submitted'",[$id]);
if(!$a){http_response_code(404);exit('This evaluation is no longer available.');}
$error='';
if($_SERVER['REQUEST_METHOD']==='POST'){
 verify_csrf();
 try{
  if(one('SELECT id FROM evaluation_external_remarks WHERE share_id=?',[$share['id']]))throw new Exception('A remark has already been submitted through this link.');
  $name=trim((string)($_POST['assessor_name']??''));$remark=trim((string)($_POST['remarks']??''));
  if(mb_strlen($name)<3||mb_strlen($name)>150||mb_strlen($remark)<10||mb_strlen($remark)>5000)throw new Exception('Enter your name and a remark between 10 and 5,000 characters.');
  sql('INSERT INTO evaluation_external_remarks(share_id,assignment_id,assessor_name,remarks) VALUES (?,?,?,?)',[$share['id'],$id,$name,$remark]);
  header('Location: '.url('external/review.php?token='.$token));exit;
 }catch(Throwable $e){$error=$e->getMessage();}
}
$existing=one('SELECT * FROM evaluation_external_remarks WHERE share_id=?',[$share['id']]);
$sc=score_assignment($id);$comments=one('SELECT * FROM evaluation_comments WHERE assignment_id=?',[$id])??[];
$ratings=all('SELECT s.title section_title,c.title criterion_title,r.rating,o.label rating_label FROM responses r JOIN criteria c ON c.id=r.criterion_id JOIN template_sections s ON s.id=c.section_id JOIN rating_options o ON o.module_id=s.module_id AND o.rating=r.rating WHERE r.assignment_id=? ORDER BY s.sort_order,s.id,c.sort_order,c.id',[$id]);
ob_start();?>
<div class="card"><h2>External assessment review</h2><p><strong>Private link:</strong> Intended only for the invited assessor. Do not forward it.</p><h3><?=h($a['module_name'])?></h3><p><b>Teacher:</b> <?=h($a['teacher'])?> | <b>Academic period:</b> <?=h($a['session_name'].' '.$a['term'])?></p><p><b>Submitted:</b> <?=h($a['submitted_at'])?></p><h2><?=number_format($sc['weighted_percent'],2)?>%</h2><h3>Section results</h3><div class="tablewrap"><table><tr><th>Section</th><th>Score</th><th>Weight</th></tr><?php foreach($sc['sections'] as $sec):?><tr><td><?=h($sec['section'])?></td><td><?=number_format($sec['percent'],2)?>%</td><td><?=number_format($sec['weight'],2)?>%</td></tr><?php endforeach;?></table></div><h3>Assessment criteria</h3><div class="tablewrap"><table><tr><th>Section</th><th>Indicator</th><th>Grade</th></tr><?php foreach($ratings as $r):?><tr><td><?=h($r['section_title'])?></td><td><?=h($r['criterion_title'])?></td><td><?=h($r['rating'].' — '.$r['rating_label'])?></td></tr><?php endforeach;?></table></div><?php foreach(['strengths'=>'Strengths','improvements'=>'Improvements','impression'=>'Impression','remarks'=>'Evaluator remarks'] as $key=>$label):?><?php if(!empty($comments[$key])):?><h3><?=h($label)?></h3><p><?=nl2br(h($comments[$key]))?></p><?php endif;?><?php endforeach;?></div>
<div class="card"><h3>External assessor's remark</h3><?php if($error):?><div class="alert error"><?=h($error)?></div><?php endif;?><?php if($existing):?><p><b><?=h($existing['assessor_name'])?></b> — <?=h($existing['created_at'])?></p><p><?=nl2br(h($existing['remarks']))?></p><p class="muted">Your remark has been submitted and is visible to school management.</p><?php else:?><form method="post"><?=token()?><input type="hidden" name="token" value="<?=h($token)?>"><label>Your full name</label><input name="assessor_name" maxlength="150" required><label>Professional remarks on this assessment</label><textarea name="remarks" rows="6" minlength="10" maxlength="5000" required></textarea><p><button type="submit" onclick="return confirm('Submit your remark? You cannot edit it afterward.')">Submit remark</button></p></form><?php endif;?></div>
<?php layout('External assessment review',ob_get_clean());
