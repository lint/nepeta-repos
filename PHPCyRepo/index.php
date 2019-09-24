<?php
spl_autoload_register(function ($class) {
  $try = [
    'src/controllers/%s.php',
    'src/models/%s.php',
    'src/%s.php',
    'framework/%s.php',
  ];

  foreach ($try as $path) {
    $s = sprintf($path, $class);
    if (file_exists($s)) {
      require $s;
      return;
    }
  }

  return false;
});

Framework::initialize();

if (!is_dir('./repo')) {
  mkdir('./repo');
}

if (!is_dir('./repo/packages')) {
  mkdir('./repo/packages');
}

if (!is_dir('./temp')) {
  mkdir('./temp');
}

Framework::set('config', require 'config.php');
Framework::set('pdo', new PDO(...Framework::get('config')['pdo']));

require 'src/routes.php';

Framework::do();