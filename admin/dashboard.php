<?php
require __DIR__.'/../includes/core.php';
require_login(['admin']);
$stats=['Registered teachers'=>(int)one("SELECT COUNT(*) n FROM users WHERE role='teacher'")['n'],'Active modules'=>(int)one('SELECT COUNT(*) n FROM modules WHERE is_active=1')['n'],'Pending assignments'=>(int)one("SELECT COUNT(*) n FROM assignments WHERE status!='submitted'")['n'],'Submitted evaluations'=>(int)one("SELECT COUNT(*) n FROM assignments WHERE status='submitted'")['n']];
$icons=['Registered teachers'=>'♙','Active modules'=>'◈','Pending assignments'=>'◷','Submitted evaluations'=>'✓'];
$modules=all("SELECT id,name FROM modules WHERE slug IN ('peer-observation','performance-appraisal') ORDER BY CASE WHEN slug='performance-appraisal' THEN 0 ELSE 1 END");
$selectedModule=(int)($_GET['module']??($modules[0]['id']??0));
if(!in_array($selectedModule,array_map(fn($m)=>(int)$m['id'],$modules),true)) $selectedModule=(int)($modules[0]['id']??0);
$cycles=all('SELECT c.id, s.name session_name, c.term FROM evaluation_cycles c JOIN academic_sessions s ON s.id=c.session_id ORDER BY c.id DESC');
$selectedCycle=(int)($_GET['cycle']??0);
if($selectedCycle && !in_array($selectedCycle,array_map(fn($c)=>(int)$c['id'],$cycles),true)) $selectedCycle=0;
$sql="SELECT a.id,a.subject_id,u.name FROM assignments a JOIN users u ON u.id=a.subject_id WHERE a.status='submitted' AND a.module_id=?";
$params=[$selectedModule];
if($selectedCycle){$sql.=' AND a.cycle_id=?';$params[]=$selectedCycle;}
$assignments=all($sql,$params);
$groups=[];
foreach($assignments as $a){
    $score=score_assignment((int)$a['id']);
    $id=(int)$a['subject_id'];
    if(!isset($groups[$id]))$groups[$id]=['name'=>$a['name'],'total'=>0.0,'count'=>0];
    $groups[$id]['total']+=(float)$score['weighted_percent'];
    $groups[$id]['count']++;
}
$rankings=[];
foreach($groups as $g)$rankings[]=['name'=>$g['name'],'score'=>round($g['total']/$g['count'],1),'count'=>$g['count']];
usort($rankings,fn($a,$b)=>($b['score']<=>$a['score']) ?: strcmp($a['name'],$b['name']));
$top=$rankings[0]??null;
$maxVisible=15;
$visible=array_slice($rankings,0,$maxVisible);
ob_start();
?>
<div class="card" style="background:linear-gradient(115deg,#74203e,#203e67);color:white;border:0"><h2 style="font-size:1.5rem;margin:0 0 5px;color:white">Welcome to 360 Evaluation</h2><p style="margin:0;color:#f9e4eb">Manage confidential staff evaluations, school information and reports from one secure workspace.</p></div>
<div class="grid"><?php foreach($stats as $label=>$count):?><div class="card"><div style="display:flex;justify-content:space-between;align-items:center"><span class="muted"><?=h($label)?></span><span style="font-size:25px;color:#8a3654"><?=h($icons[$label])?></span></div><div class="stat"><?=$count?></div></div><?php endforeach;?></div>
<div class="card"><h2>Teacher Performance Analytics</h2><p class="muted">Confidential management-only rankings. Each teacher's score is the average of their submitted evaluations in the selected module and cycle.</p>
<form method="get" class="analytics-filters">
<div><label for="module">Evaluation type</label><select name="module" id="module"><?php foreach($modules as $m):?><option value="<?=(int)$m['id']?>" <?=$selectedModule===(int)$m['id']?'selected':''?>><?=h($m['name'])?></option><?php endforeach;?></select></div>
<div><label for="cycle">Academic cycle</label><select name="cycle" id="cycle"><option value="0">All cycles</option><?php foreach($cycles as $c):?><option value="<?=(int)$c['id']?>" <?=$selectedCycle===(int)$c['id']?'selected':''?>><?=h($c['session_name'].' — '.$c['term'])?></option><?php endforeach;?></select></div>
<div><button type="submit">Apply Filters</button></div></form>
<?php if($top):?>
<div class="top-performer"><span class="top-trophy" aria-hidden="true">★</span><div><span class="top-label">Highest-Rated Teacher</span><h3><?=h($top['name'])?></h3><span class="top-meta"><?=h($top['count'])?> submitted evaluation<?= $top['count']===1?'':'s'?></span></div><div class="top-score"><?=number_format($top['score'],1)?>%</div></div>
<h3 style="margin-top:1.5rem">Teacher Scores — Highest to Lowest</h3><div class="teacher-chart" role="img" aria-label="Horizontal bar chart comparing teacher evaluation percentages">
<?php foreach($visible as $i=>$r):?><div class="teacher-bar-row"><div class="teacher-bar-name" title="<?=h($r['name'])?>"><?=h($r['name'])?></div><div class="teacher-bar-track"><div class="teacher-bar-fill <?=$i===0?'leader':''?>" style="width:<?=max(0,min(100,$r['score']))?>%"></div></div><strong class="teacher-bar-value"><?=number_format($r['score'],1)?>%</strong></div><?php endforeach;?></div>
<?php if(count($rankings)>$maxVisible):?><p class="muted">Showing top <?=$maxVisible?> of <?=count($rankings)?> teachers. View detailed results for all teachers in Confidential Reports.</p><?php endif;?>
<?php else:?><div class="analytics-empty">No completed evaluations found for these filters. Scores will appear automatically when evaluations are submitted.</div><?php endif;?></div>
<div class="card"><h2>Overall 360 Evaluation</h2><p class="muted">Combine completed evaluations from two or more modules with configurable weights, view overall rankings and identify the highest-performing teacher.</p><a class="btn" href="<?=url('management/consolidated.php')?>">Open Overall 360 Chart &amp; Rankings →</a></div>
<div class="card"><h2>Quick Actions</h2><div class="actions quick-actions"><a class="btn" href="<?=url('admin/teachers.php')?>">Register Teachers</a><a class="btn alt" href="<?=url('admin/modules.php')?>">Evaluation Modules</a><a class="btn" href="<?=url('admin/assignments.php')?>">Assign Evaluations</a><a class="btn alt" href="<?=url('management/reports.php')?>">Confidential Reports</a><a class="btn" href="<?=url('admin/settings.php')?>">School Settings</a></div></div>
<?php layout('Administrative Dashboard',ob_get_clean());
