<?php
class Utils {
  public static function checkCsrfToken() {
    if (!isset($_POST['csrf_token']) || $_POST['csrf_token'] != Framework::$auth->getCsrfToken())
      Framework::fail(500, 'The provided CSRF token is incorrect. Please re-authenticate.');
  }

  public static function requireSuperuser() {
    if (!Framework::$auth->isSuperuser())
      Framework::fail(403, 'You are not authorized to perform this operation.');
  }

  public static function getValidControlKeys() {
    return ['Package', 'Name', 'Version', 'Maintainer', 'Author',
    'Description', 'Section', 'Priority', 'Installed-Size',
    'Essential', 'Build-Essential', 'Architecture', 'Origin',
    'Bugs', 'Homepage', 'Tag', 'Multi-Arch', 'Depends',
    'Pre-Depends', 'Recommends', 'Suggests', 'Breaks',
    'Conflicts', 'Replaces', 'Provides', 'Filename', 'Size',
    'MD5sum'];
  }

  public static function formatKey($key) {
    return str_replace(' ', '-', ucwords(strtolower(str_replace('-', ' ', $key))));
  }
  
  public static function releaseMD5Sum($file) {
    return ' ' . md5_file($file) . ' ' . filesize($file) . ' ' . $file . "\n";
  }
  
  public static function generateReleasesFile() {
    $cwd = getcwd();
  
    chdir('./repo/');
    if (file_exists('Release')) unlink('Release');
  
    $out = 'Origin: ' . Framework::get('config')['repo']['name'] . "\n";
    $out .= 'Label: ' . Framework::get('config')['repo']['name'] . "\n";
    $out .= 'Suite: stable' . "\n";
    $out .= 'Version: 1.0' . "\n";
    $out .= 'Architectures: iphoneos-arm' . "\n";
    $out .= 'Components: main' . "\n";
    $out .= 'Codename: ' . Framework::get('config')['repo']['codename'] . "\n";
    $out .= 'Description: ' . Framework::get('config')['repo']['description'] . "\n";
    $out .= 'MD5Sum:' . "\n";
    $out .= Utils::releaseMD5Sum('Packages');
    $out .= Utils::releaseMD5Sum('Packages.bz2');
    $out .= Utils::releaseMD5Sum('Packages.gz');
  
    file_put_contents('Release', $out);
    
    chdir($cwd);
  }
  
  public static function generatePackagesFile() {
    $validControlKeys = Utils::getValidControlKeys();
    $packages = Package::all('hidden=0');
    $cwd = getcwd();
  
    chdir('./repo/');
    if (file_exists('Packages')) unlink('Packages');
    if (file_exists('Packages.bz2')) unlink('Packages.bz2');
    if (file_exists('Packages.gz')) unlink('Packages.gz');
  
    $out = '';
    foreach ($packages as $package) {
      foreach ($package->data as $key => $value) {
        if (!is_numeric($key) && (in_array($key, $validControlKeys) || $key == 'Depiction')) {
          switch ($key) {
            case 'Filename':
              $out .= $key . ': packages/' . $value . "\n";
              break;
            case 'Depiction':
              $out .= $key . ': ' . Framework::get('config')['repo']['url'] . 'depiction/' . $package->Package . "\n";
              break;
            case 'Build-Essential':
            case 'Essential':
              if ($value) $out .= $key . ': yes';
              break;
            default:
              if (!empty($value)) $out .= $key . ': ' . $value . "\n";
          }
        }
      }
      $out .= "\n";
    }
  
    file_put_contents('Packages', $out);
    shell_exec('gzip -c9 Packages > Packages.gz');
    shell_exec('bzip2 -c9 Packages > Packages.bz2');
  
    chdir($cwd);
    Utils::generateReleasesFile();
  }
}