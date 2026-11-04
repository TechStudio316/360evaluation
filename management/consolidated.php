<?php
require __DIR__.'/../includes/core.php';
require_login(['admin','management']);
$modules=all("SELECT id,name,slug,is_active FROM modules WHERE id IN (SELECT DISTINCT module_id FROM assignments WHERE status='submitted') ORDER BY id");
$cycles=all('SELECT c.id,s.name session_name,c.term FROM evaluation_cycles c JOIN academic_sessions s ON s.id=c.session_id ORDER BY c.id DESC');
$cycle=(int)($_GET['cycle']??0);
if($cycle && !in_array($cycle,array_map(fn($c)=>(int)$c['id'],$cycles),true))$cycle=0;
$settings=school_settings();
$stored=json_decode($settings['consolidation_weights']??'{}',true);if(!is_array($stored))$stored=[];
$enabled=json_decode($settings['consolidation_modules']??'[]',true);if(!is_array($enabled))$enabled=[];
$moduleIds=array_map(fn($m)=>(int)$m['id'],$modules);
$enabled=array_values(array_intersect(array_map('intval',$enabled),$moduleIds));
if(!$enabled)$enabled=$moduleIds;
$weights=[];foreach($modules as $m){$id=(int)$m['id'];$weights[$id]=isset($stored[$id])?max(0,min(100,(float)$stored[$id])):($m['slug']==='performance-appraisal'?50.0:($m['slug']==='peer-observation'?50.0:0.0));}
if($_SERVER['REQUEST_METHOD']==='POST'){
 require_login(['admin']);verify_csrf();
 $chosen=array_values(array_intersect(array_map('intval',(array)($_POST['modules']??[])),$moduleIds));
 $newWeights=[];$total=0;
 foreach($modules as $m){$id=(int)$m['id'];$value=filter_var($_POST['weights'][$id]??null,FILTER_VALIDATE_FLOAT);$value=$value===false?-1:(float)$value;if($value<0||$value>100){flash('Enter weights from 0 to 100.','error');go('management/consolidated.php');}$newWeights[$id]=$value;if(in_array($id,$chosen,true))$total+=$value;}
 if(!$chosen||abs($total-100)>0.01){flash('Select at least one module and make its selected weights total exactly 100%.','error');go('management/consolidated.php');}
 sql('INSERT INTO settings (`key`,`value`) VALUES (?,?) ON DUPLICATE KEY UPDATE `value`=VALUES(`value`)',['consolidation_weights',json_encode($newWeights)]);
 sql('INSERT INTO settings (`key`,`value`) VALUES (?,?) ON DUPLICATE KEY UPDATE `value`=VALUES(`value`)',['consolidation_modules',json_encode($chosen)]);
 audit('consolidation_updated','Modules '.implode(',',$chosen).' weights '.json_encode($newWeights));flash('Overall evaluation configuration saved.');go('management/consolidated.php');
}
$sumSelected=array_sum(array_map(fn($id)=>$weights[$id]??0,$enabled));
// A teacher is eligible for the consolidated score only if every selected module has a submitted evaluation.
$query="SELECT a.id,a.subject_id,a.module_id,u.name teacher_name FROM assignments a JOIN users u ON u.id=a.subject_id WHERE a.status='submitted' AND u.role='teacher'";
$params=[];if($cycle){$query.=' AND a.cycle_id=?';$params[]=$cycle;}
$records=all($query,$params);$people=[];
foreach($records as $r){$tid=(int)$r['subject_id'];$mid=(int)$r['module_id'];if(!in_array($mid,$enabled,true))continue;
 if(!isset($people[$tid]))$people[$tid]=['id'=>$tid,'name'=>$r['teacher_name'],'modules'=>[]];
 $score=score_assignment((int)$r['id']);$people[$tid]['modules'][$mid][]=(float)$score['weighted_percent'];
}
$rankings=[];$incomplete=0;
foreach($people as $person){$parts=[];$overall=0;$valid=$sumSelected>0;
 foreach($enabled as $mid){if(empty($person['modules'][$mid])){$valid=false;continue;}$avg=array_sum($person['modules'][$mid])/count($person['modules'][$mid]);$parts[$mid]=['score'=>$avg,'count'=>count($person['modules'][$mid])];$overall+=$avg*($weights[$mid]??0)/100;}
 if($valid){$rankings[]=['name'=>$person['name'],'id'=>$person['id'],'score'=>round($overall,2),'parts'=>$parts];}else $incomplete++;
}
usort($rankings,fn($a,$b)=>($b['score']<=>$a['score'])?:strcmp($a['name'],$b['name']));
if(isset($_GET['csv'])){
 header('Content-Type: text/csv; charset=utf-8');header('Content-Disposition: attachment; filename="bgb_overall_evaluation.csv"');
 $f=fopen('php://output','w');fputcsv($f,array_merge(['Rank','Teacher'],array_map(fn($m)=>$m['name'],array_filter($modules,fn($m)=>in_array((int)$m['id'],$enabled,true))),['Overall %']));
 foreach($rankings as $i=>$r){$line=[$i+1,$r['name']];foreach($modules as $m)if(in_array((int)$m['id'],$enabled,true))$line[]=round($r['parts'][(int)$m['id']]['score'],2);$line[]=$r['score'];fputcsv($f,$line);}exit;
}
ob_start();?>
<style>
.overall-hero{background:linear-gradient(115deg,#781f42,#192e56);color:#fff;border-radius:17px;padding:23px;margin-bottom:16px}.overall-hero h2{color:#fff;margin:0 0 6px}.overall-hero p{color:#f4dfe9;margin:0}
.overall-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:13px;margin:15px 0}.overall-stat{background:#fff;border:1px solid #eee2e7;border-radius:14px;padding:17px}.overall-stat strong{font-size:25px;color:#792744;display:block}.overall-stat span{color:#687081;font-size:13px}
.overall-filter{display:flex;flex-wrap:wrap;align-items:end;gap:12px}.overall-filter>*{flex:1 1 160px}.overall-chart{display:grid;gap:13px;margin-top:20px}.overall-row{display:grid;grid-template-columns:minmax(85px,175px) minmax(0,1fr) 65px;align-items:center;gap:10px}.overall-track{height:21px;border-radius:7px;background:#e9e9f0;overflow:hidden}.overall-fill{height:100%;background:linear-gradient(90deg,#853050,#345b91);border-radius:7px}.overall-row:first-child .overall-fill{background:linear-gradient(90deg,#c69b32,#f0c85b)}.overall-name{font-size:13px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.overall-score{text-align:right;font-weight:700}.overall-top{background:linear-gradient(115deg,#fff6db,#fff);border:1px solid #e6cc86;border-radius:15px;padding:17px;display:flex;justify-content:space-between;gap:15px;align-items:center}.overall-top strong{font-size:24px;color:#704c0a}.overall-table{width:100%;border-collapse:collapse}.overall-table th,.overall-table td{padding:10px;border-bottom:1px solid #e9e9ef;text-align:left}.overall-table th{white-space:nowrap}.overall-weights{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:10px}.overall-weights label{display:block}.overall-weights input[type=number]{max-width:115px}.overall-note{color:#657080;font-size:13px}
@media(max-width:620px){.overall-grid{grid-template-columns:1fr 1fr}.overall-row{grid-template-columns:90px minmax(0,1fr) 53px;gap:7px}.overall-hero{padding:17px}.overall-top strong{font-size:19px}.overall-name{font-size:12px}}
@media print{.top,.side,.nav-backdrop,.page-heading,.no-print{display:none!important}.shell,main{display:block!important;width:100%!important;padding:0!important}.card{box-shadow:none!important}.overall-chart{break-inside:avoid}body{background:white!important}}
</style>
<div class="overall-hero"><h2>Overall 360 Evaluation</h2><p>Confidential management analytics • Configurable weighted consolidation of completed evaluation modules</p></div>
<div class="card no-print"><form method="get" class="overall-filter"><div><label>Academic session / term</label><select name="cycle"><option value="0">All cycles</option><?php foreach($cycles as $c):?><option value="<?=$c['id']?>" <?=$cycle===(int)$c['id']?'selected':''?>><?=h($c['session_name'].' — '.$c['term'])?></option><?php endforeach;?></select></div><div><button type="submit">Apply Filter</button></div><div><a class="btn alt" href="?cycle=<?=$cycle?>&csv=1">Export CSV</a></div><div><button type="button" onclick="window.print()">Print / Save PDF</button></div></form></div>
<?php if(abs($sumSelected-100)>0.01):?><div class="card"><strong>Configuration needed:</strong> Selected module weights currently total <?=number_format($sumSelected,1)?>%. An administrator must save weights totaling 100% before overall results are meaningful.</div><?php endif;?>
<div class="overall-grid"><div class="overall-stat"><span>Teachers with complete evaluations</span><strong><?=count($rankings)?></strong></div><div class="overall-stat"><span>Teachers missing selected modules</span><strong><?=$incomplete?></strong></div><div class="overall-stat"><span>Modules in overall score</span><strong><?=count($enabled)?></strong></div></div>
<?php if($rankings && abs($sumSelected-100)<0.01):$top=$rankings[0];?><div class="overall-top"><div><span>★ Highest Overall Evaluation</span><h2 style="margin:7px 0"><?=h($top['name'])?></h2><small>Based on <?=count($enabled)?> selected evaluation module(s)</small></div><strong><?=number_format($top['score'],1)?>%</strong></div><?php endif;?>
<div class="card"><h2>Overall Teacher Rankings</h2><p class="overall-note">Each teacher's module score is the average of their submitted evaluations for the selected period. Only teachers with completed results in every selected module are ranked. All percentages are normalized before weighting.</p>
<?php if($rankings && abs($sumSelected-100)<0.01):?><div class="overall-chart" role="img" aria-label="Overall evaluation percentage comparison by teacher"><?php foreach(array_slice($rankings,0,40) as $r):?><div class="overall-row"><span class="overall-name" title="<?=h($r['name'])?>"><?=h($r['name'])?></span><div class="overall-track"><div class="overall-fill" style="width:<?=max(0,min(100,$r['score']))?>%"></div></div><span class="overall-score"><?=number_format($r['score'],1)?>%</span></div><?php endforeach;?></div><?php else:?><p>No eligible completed results yet, or configuration weights need correction.</p><?php endif;?></div>
<div class="card"><h2>Detailed Consolidated Scores</h2><div class="tablewrap"><table class="overall-table"><thead><tr><th>Rank</th><th>Teacher</th><?php foreach($modules as $m)if(in_array((int)$m['id'],$enabled,true)):?><th><?=h($m['name'])?> (<?=number_format($weights[(int)$m['id']],1)?>%)</th><?php endif;?><th>Overall</th></tr></thead><tbody><?php foreach($rankings as $i=>$r):?><tr><td><?=$i+1?></td><td><?=h($r['name'])?></td><?php foreach($modules as $m)if(in_array((int)$m['id'],$enabled,true)):?><td><?=number_format($r['parts'][(int)$m['id']]['score'],1)?>%</td><?php endif;?><td><strong><?=number_format($r['score'],1)?>%</strong></td></tr><?php endforeach;?></tbody></table></div></div>
<?php if(me()['role']==='admin'):?><div class="card no-print"><h2>Consolidation Settings</h2><p class="overall-note">Choose any available modules, including future modules when their completed results exist. Set selected weights to total exactly 100%. Inactive modules with historical submitted evaluations can still be included for historical reporting.</p><form method="post"><?=token()?><div class="overall-weights"><?php foreach($modules as $m):$mid=(int)$m['id'];?><div><label><input type="checkbox" name="modules[]" value="<?=$mid?>" <?=in_array($mid,$enabled,true)?'checked':''?>> <?=h($m['name'])?></label><label for="weight<?=$mid?>">Weight (%)</label><input type="number" id="weight<?=$mid?>" name="weights[<?=$mid?>]" min="0" max="100" step="0.01" value="<?=h($weights[$mid])?>"></div><?php endforeach;?></div><div class="actions"><button type="submit">Save Consolidation Settings</button></div></form></div><?php endif;?>
<?php layout('Overall 360 Evaluation',ob_get_clean());
