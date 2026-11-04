<?php
require __DIR__.'/../includes/core.php';require_login(['admin']);
$fields=['school_name'=>'School Name','school_motto'=>'Motto / Tagline','school_address'=>'Registered / Postal Address','school_phone'=>'School Phone Number','school_email'=>'School Email','school_website'=>'Website','school_head'=>'Principal / Head of School','report_footer'=>'Confidential Report Footer'];
if($_SERVER['REQUEST_METHOD']==='POST'){
 verify_csrf();
 foreach($fields as $key=>$label){$value=trim((string)($_POST[$key]??''));if(mb_strlen($value)>1000){flash($label.' is too long.','error');go('admin/settings.php');}if($key==='school_email'&&$value&&!filter_var($value,FILTER_VALIDATE_EMAIL)){flash('Enter a valid school email.','error');go('admin/settings.php');}if($key==='school_website'&&$value&&!filter_var($value,FILTER_VALIDATE_URL)){flash('Enter a full website URL, including https://','error');go('admin/settings.php');}sql('INSERT INTO settings (`key`,`value`) VALUES (?,?) ON DUPLICATE KEY UPDATE `value`=VALUES(`value`)',[$key,$value]);}
 if(isset($_FILES['logo'])&&$_FILES['logo']['error']!==UPLOAD_ERR_NO_FILE){
  $f=$_FILES['logo'];$allowed=['image/png'=>'png','image/jpeg'=>'jpg','image/webp'=>'webp'];
  if($f['error']!==UPLOAD_ERR_OK||$f['size']>2*1024*1024||$f['size']<100||!is_uploaded_file($f['tmp_name'])){flash('Logo upload failed. Maximum 2 MB.','error');go('admin/settings.php');}
  $mime=(new finfo(FILEINFO_MIME_TYPE))->file($f['tmp_name']);$info=@getimagesize($f['tmp_name']);
  if(!isset($allowed[$mime])||!$info||$info[0]>5000||$info[1]>5000){flash('Upload a valid PNG, JPEG or WebP image.','error');go('admin/settings.php');}
  $relative='assets/uploads/school-logo-'.bin2hex(random_bytes(12)).'.'.$allowed[$mime];$target=dirname(__DIR__).'/'.$relative;
  if(!move_uploaded_file($f['tmp_name'],$target)){flash('Cannot save logo. Check assets/uploads permissions.','error');go('admin/settings.php');}
  $old=school_settings()['school_logo']??'';sql('INSERT INTO settings (`key`,`value`) VALUES (?,?) ON DUPLICATE KEY UPDATE `value`=VALUES(`value`)',['school_logo',$relative]);
  if(preg_match('~^assets/uploads/school-logo-[a-f0-9]{24}\.(png|jpg|webp)$~',$old)&&is_file(dirname(__DIR__).'/'.$old))@unlink(dirname(__DIR__).'/'.$old);
 }
 audit('school_settings_updated','School profile updated');flash('School information saved successfully.');go('admin/settings.php');
}
$settings=school_settings();ob_start();?>
<div class="card"><h2>School Profile & Report Branding</h2><p class="muted">These details appear in the application header and confidential printable evaluation reports.</p><form method="post" enctype="multipart/form-data"><?=token()?>
<div class="formgrid"><?php foreach($fields as $key=>$label):?><div><label for="<?=h($key)?>"><?=h($label)?></label><?php if(in_array($key,['school_address','report_footer'],true)):?><textarea id="<?=h($key)?>" name="<?=h($key)?>" rows="3"><?=h($settings[$key]??'')?></textarea><?php else:?><input id="<?=h($key)?>" name="<?=h($key)?>" type="<?= $key==='school_email'?'email':($key==='school_website'?'url':'text')?>" value="<?=h($settings[$key]??'')?>" <?= $key==='school_name'?'required':'' ?>><?php endif;?></div><?php endforeach;?></div>
<h3>School Logo</h3><?php if(school_logo_url()):?><p><img src="<?=h(school_logo_url())?>" alt="Current school logo" style="width:100px;height:100px;object-fit:contain"></p><?php endif;?><label for="logo">Upload Logo (PNG, JPG, WebP, up to 2 MB)</label><input type="file" name="logo" id="logo" accept="image/png,image/jpeg,image/webp"><div class="actions"><button type="submit">Save School Information</button><a class="btn alt" href="<?=url('management/reports.php')?>">View Reports</a></div></form></div>
<?php layout('School Settings',ob_get_clean());
