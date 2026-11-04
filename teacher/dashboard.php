<?php require __DIR__.'/../includes/core.php';$u=require_login(['teacher']);ensure_teacher_self_evaluations((int)$u['id']);$rows=all("SELECT a.*,m.name module_name,t.name teacher,c.term,s.name session_name FROM assignments a JOIN modules m ON m.id=a.module_id JOIN users t ON t.id=a.subject_id JOIN evaluation_cycles c ON c.id=a.cycle_id JOIN academic_sessions s ON s.id=c.session_id WHERE a.evaluator_id=? AND m.is_active=1 ORDER BY a.id DESC",[$u['id']]);ob_start();?><div class="card"><p>Your Personal/Self-Evaluation is available automatically for every open evaluation cycle. Peer observations remain separately assigned. Confidential evaluation scores are accessible only to school management.</p><div class="tablewrap teacher-evaluation-table"><table><tr><th>Teacher</th><th>Module</th><th>Cycle</th><th>Status</th><th>Action</th></tr><?php foreach($rows as $r)echo '<tr><td data-label="Teacher">'.h($r['teacher']).'</td><td data-label="Module">'.h($r['module_name']).'</td><td data-label="Cycle">'.h($r['session_name'].' '.$r['term']).'</td><td data-label="Status">'.h($r['status']).'</td><td data-label="Action">'.($r['status']==='submitted'?'Submitted':'<a class="btn" href="'.url('evaluate.php?id='.$r['id']).'">Open form</a>').'</td></tr>';?></table></div></div><style>
@media(max-width:650px){
.teacher-evaluation-table{overflow:visible!important}
.teacher-evaluation-table table,.teacher-evaluation-table tbody{display:block!important;width:100%!important;min-width:0!important}
.teacher-evaluation-table tr{display:block!important;margin:0 0 14px;padding:12px;border:1px solid #e8dfe4;border-radius:12px;background:#fff}
.teacher-evaluation-table tr:first-child{display:none!important}
.teacher-evaluation-table td{display:flex!important;justify-content:space-between;align-items:center;gap:10px;padding:8px 2px;white-space:normal!important;overflow-wrap:anywhere!important;text-align:right}
.teacher-evaluation-table td::before{content:attr(data-label);font-weight:700;text-align:left;color:#70263c;flex:0 0 32%}
.teacher-evaluation-table td:last-child{border-bottom:0;align-items:stretch}
.teacher-evaluation-table td:last-child .btn{display:inline-flex!important;align-items:center;justify-content:center;min-height:44px;white-space:normal!important;min-width:0!important;flex:1}
}
</style>
<?php layout('My evaluations',ob_get_clean());