<?php
require_once __DIR__.'/config.php';
if (session_status() !== PHP_SESSION_ACTIVE) { session_set_cookie_params(['httponly'=>true,'secure'=>!empty($_SERVER['HTTPS'])&&$_SERVER['HTTPS']!=='off','samesite'=>'Lax']); session_start(); }
function db(): PDO { static $db; if (!$db) { $db=new PDO('mysql:host='.DB_HOST.';dbname='.DB_NAME.';charset=utf8mb4',DB_USER,DB_PASS,[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,PDO::ATTR_EMULATE_PREPARES=>false]); } return $db; }
function sql($q,$params=[]):PDOStatement { $s=db()->prepare($q);$s->execute($params);return $s; }
function all($q,$params=[]):array{return sql($q,$params)->fetchAll();}
function one($q,$params=[]):?array{$r=sql($q,$params)->fetch();return $r?:null;}
function h($s):string{return htmlspecialchars((string)($s??''),ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');}
function base():string {if(APP_BASE!=='')return rtrim(APP_BASE,'/');$path=str_replace('\\','/',dirname($_SERVER['SCRIPT_NAME']??'/evaluation/index.php'));foreach(['/admin','/teacher','/supervisor','/management'] as $sub){if(str_ends_with($path,$sub))$path=substr($path,0,-strlen($sub));}return rtrim($path,'/');}
function url($p=''):string{return base().'/'.ltrim($p,'/');}
function go($p):never{header('Location: '.url($p));exit;}
function csrf():string {return $_SESSION['csrf']??=bin2hex(random_bytes(32));}
function verify_csrf():void {if(!hash_equals(csrf(),(string)($_POST['csrf']??''))) {http_response_code(419);exit('Invalid request token. Refresh and retry.');}}
function token():string{return '<input type="hidden" name="csrf" value="'.h(csrf()).'">';}
function me():?array{return $_SESSION['user']??null;}
function require_login(array $roles=[]):array {if(!me())go('login.php');if($roles&&!in_array(me()['role'],$roles,true)){http_response_code(403);exit('Access denied');}return me();}
function flash($message,$kind='success'):void{$_SESSION['flash']=[$message,$kind];}
function phone($v):string{$v=preg_replace('/[^0-9+]/','',trim($v));if(str_starts_with($v,'+234'))$v='0'.substr($v,4);if(str_starts_with($v,'234'))$v='0'.substr($v,3);return $v;}
function audit($action,$details=''):void {sql('INSERT INTO audit_logs(user_id,action,details) VALUES (?,?,?)',[me()['id']??null,$action,$details]);}
function school_settings():array {static $data=null;if($data===null){$data=['school_name'=>'BGB Group of Schools','school_motto'=>'','school_address'=>'','school_phone'=>'','school_email'=>'','school_website'=>'','school_head'=>'','school_logo'=>'','report_footer'=>'Confidential — For authorized school management only.'];try {foreach(all('SELECT `key`,`value` FROM settings') as $r)$data[$r['key']]=$r['value'];}catch(Throwable $e){error_log('Settings unavailable: '.$e->getMessage());}}return $data;}
function school_logo_url():string {$s=school_settings();$logo=$s['school_logo']??'';return preg_match('~^assets/uploads/school-logo-[a-f0-9]{24}\\.(png|jpg|webp)$~',$logo)?url($logo):'';}
function layout($title,$body):void {
 $u=me();$role=$u['role']??'';$school=school_settings();
 $nav=$role==='admin'?['admin/dashboard.php'=>['Dashboard','▦'],'admin/teachers.php'=>['Teachers','♙'],'admin/modules.php'=>['Evaluation Modules','◈'],'admin/assignments.php'=>['Assignments','☷'],'management/consolidated.php'=>['Overall 360 Scores','▥'],'management/reports.php'=>['Confidential Results','▤'],'admin/cycles.php'=>['Academic Cycles','◷'],'admin/settings.php'=>['School Settings','⚙']]:($role==='management'?['management/reports.php'=>['Management Reports','▤'],'management/consolidated.php'=>['Overall 360 Scores','▥']]:($role==='supervisor'?['supervisor/dashboard.php'=>['My Appraisals','▤']]:['teacher/dashboard.php'=>['My Evaluations','▤']]));
 $current=ltrim(parse_url($_SERVER['REQUEST_URI']??'',PHP_URL_PATH)??'','/');$logo=school_logo_url();
 echo '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="theme-color" content="#14213d"><title>'.h($title).' — '.h($school['school_name']).'</title><link rel="stylesheet" href="'.url('assets/css/style.css?v=6').'"></head><body><header class="top"><button type="button" class="menu-toggle" id="menuToggle" aria-label="Toggle navigation" aria-expanded="false">☰</button><a class="brand" href="'.url('index.php').'">'.($logo?'<img class="brand-logo" src="'.h($logo).'" alt="School logo">':'<span class="brand-mark">360</span>').'<span class="brand-copy"><strong>'.h($school['school_name']).'</strong><small>360 Evaluation</small></span></a><div class="top-actions">'.($u?'<span class="user-pill">'.h($u['name']).' <small>· '.h(ucfirst($role)).'</small></span><a class="top-link" href="'.url('password.php').'">Password</a><a class="top-link" href="'.url('logout.php').'">Logout</a>':'').'</div></header><div class="shell">';
 if($u){echo '<nav class="side" id="sidebar"><div class="side-caption">WORKSPACE</div>';foreach($nav as $link=>$item){$active=str_ends_with($current,$link)?' active':'';echo '<a class="nav-link'.$active.'" href="'.url($link).'"><span class="nav-icon" aria-hidden="true">'.h($item[1]).'</span><span>'.h($item[0]).'</span></a>';}echo '<div class="side-footer">Secure • Confidential<br>School performance platform</div></nav><div class="nav-backdrop" id="navBackdrop"></div>';}
 echo '<main><div class="page-heading"><div class="eyebrow">BGB / 360 EVALUATION</div><h1>'.h($title).'</h1></div>';
 if(isset($_SESSION['flash'])){[$msg,$kind]=$_SESSION['flash'];unset($_SESSION['flash']);echo '<div class="alert '.h($kind).'">'.h($msg).'</div>';}echo $body.'</main></div><script src="'.url('assets/js/app.js?v=2').'" defer></script></body></html>';
}
function is_self_module($slug):bool{return in_array((string)$slug,['personal-evaluation','self-evaluation'],true);}
/** Automatically provision personal evaluations for the logged-in active teacher.
 * No administrator assignment is required. One per open cycle; existing drafts/submissions survive.
 */
function ensure_teacher_self_evaluations(int $teacherId):void {
    $teacher=one("SELECT id FROM users WHERE id=? AND role='teacher' AND is_active=1",[$teacherId]);
    if(!$teacher)return;
    $modules=all("SELECT id FROM modules WHERE slug IN ('personal-evaluation','self-evaluation') AND evaluator_role='teacher' AND is_active=1");
    if(!$modules)return;
    $cycles=all('SELECT id FROM evaluation_cycles WHERE is_open=1');
    foreach($modules as $module){
        foreach($cycles as $cycle){
            sql('INSERT IGNORE INTO assignments(module_id,cycle_id,evaluator_id,subject_id) VALUES (?,?,?,?)',[(int)$module['id'],(int)$cycle['id'],$teacherId,$teacherId]);
        }
    }
}
function dashboard_path($role):string{return match($role){'admin'=>'admin/dashboard.php','management'=>'management/reports.php','supervisor'=>'supervisor/dashboard.php',default=>'teacher/dashboard.php'};}
function score_assignment(int $id):array{$a=one('SELECT a.*,m.rating_direction FROM assignments a JOIN modules m ON m.id=a.module_id WHERE a.id=?',[$id]);$sections=all('SELECT * FROM template_sections WHERE module_id=? ORDER BY sort_order,id',[$a['module_id']]);$out=[];$weighted=0;$weightSum=0;$raw=0;$max=0;foreach($sections as $s){$criteria=all('SELECT c.id,c.title,r.rating FROM criteria c LEFT JOIN responses r ON r.criterion_id=c.id AND r.assignment_id=? WHERE c.section_id=? ORDER BY c.sort_order,c.id',[$id,$s['id']]);$opts=one('SELECT MIN(rating) lo,MAX(rating) hi FROM rating_options WHERE module_id=?',[$a['module_id']]);$n=count($criteria);$sum=0;$complete=0;foreach($criteria as $c){if($c['rating']!==null){$complete++;$sum+=($a['rating_direction']==='low'?(int)$opts['hi']+(int)$opts['lo']-(int)$c['rating']:(int)$c['rating']);}}$possible=$n*(int)$opts['hi'];$pct=$possible?100*$sum/$possible:0;$raw+=$sum;$max+=$possible;$weight=(float)$s['weight'];$weighted+=$pct*$weight;$weightSum+=$weight;$out[]=['section'=>$s['title'],'score'=>$sum,'max'=>$possible,'percent'=>$pct,'weight'=>$weight,'complete'=>$complete,'count'=>$n];}return ['sections'=>$out,'raw'=>$raw,'max'=>$max,'raw_percent'=>$max?100*$raw/$max:0,'weighted_percent'=>$weightSum?($weighted/$weightSum):($max?100*$raw/$max:0),'weight_sum'=>$weightSum];}
