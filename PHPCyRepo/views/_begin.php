<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title><?php echo $repo['name']; ?></title>
    <link rel="stylesheet" href="<?php echo $repo['url']; ?>assets/style.css" />
  </head>
  <body>
<?php
if (!empty($errors)) {
  foreach ($errors as $err) {
?>
    <div class="error"><?=$err?></div>
<?php
  }
}
?>
