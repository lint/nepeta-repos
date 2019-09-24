<?php
class PackageController {
  public static function depiction($id) {
    $package = Package::get('Package', $id);
    if (!$package) Framework::notFound();
  
    $package->views++;
    $package->save();
    
    $view = new View('depiction.php');
    $view->render(['repo' => Framework::get('config')['repo'], 'package' => $package]);
  }

  public static function view($id) {
    $package = Package::get('Package', $id);
    if (!$package) Framework::notFound();
  
    $view = new View('package.php');
    $view->render(['repo' => Framework::get('config')['repo'], 'package' => $package]);
  }

  public static function updateDepiction($id) {
    Utils::checkCsrfToken();
    $package = Package::get('Package', $id);
    if (!$package) Framework::notFound();
  
    $package->Depiction = $_POST['depiction'];
    $package->save();
  
    Framework::redirect('/admin/package/' . $id);
  }

  public static function delete($id) {
    Utils::checkCsrfToken();
    $package = Package::get('Package', $id);
    if (!$package) Framework::notFound();

    $package->delete();
    if (file_exists('./repo/packages/' . $package->Filename)) unlink('./repo/packages/' . $package->Filename);
    Utils::generatePackagesFile();
    Framework::redirect('/admin');
  }

  public static function updateVisibility($id) {
    $package = Package::get('Package', $id);
    if (!$package) Framework::notFound();

    if ($package->hidden == 0) $package->hidden = 1;
    else $package->hidden = 0;
    $package->save();

    Utils::generatePackagesFile();
    Framework::redirect('/admin/package/' . $package);
  }

  public static function upload() {
    Utils::checkCsrfToken();

    $validControlKeys = Utils::getValidControlKeys();
    $cwd = getcwd();
    try {
      $temp_dir = './temp/';
      $packages_dir = './repo/packages/';

      if (!isset($_FILES['file']['error']) || is_array($_FILES['file']['error'])) {
        throw new RuntimeException('Invalid parameters.');
      }

      switch ($_FILES['file']['error']) {
        case UPLOAD_ERR_OK:
          break;
        case UPLOAD_ERR_NO_FILE:
          throw new RuntimeException('No file sent.');
        case UPLOAD_ERR_INI_SIZE:
        case UPLOAD_ERR_FORM_SIZE:
          throw new RuntimeException('Exceeded filesize limit.');
        default:
          throw new RuntimeException('Unknown errors.');
      }

      $finfo = new finfo(FILEINFO_MIME_TYPE);
      $mime = $finfo->file($_FILES['file']['tmp_name']);

      if (!move_uploaded_file($_FILES['file']['tmp_name'], $temp_dir . $_FILES['file']['name'])) {
        throw new RuntimeException('Failed to move uploaded file.');
      }

      chdir($temp_dir);
      shell_exec('ar x ' . $_FILES['file']['name']);
      if (file_exists('control.tar.gz')) {
        shell_exec('tar -xvf control.tar.gz');
      } elseif (file_exists('control.tar.lzma')) {
        shell_exec('tar -xvf --lzma control.tar.lzma');
      } else {
        throw new RuntimeException('.deb is corrupted.');
      }

      if (file_exists('control')) {
        $data = [];
        $control = explode("\n", file_get_contents('control'));
        foreach ($control as $line) {
          $exploded = explode(':', str_replace(': ', ':', $line), 2);
          $formattedKey = Utils::formatKey($exploded[0]);
          if (count($exploded) == 2 && in_array($formattedKey, $validControlKeys)) $data[$formattedKey] = $exploded[1];
        }
        
        $data['Filename'] = $_FILES['file']['name'];
        $data['Size'] = filesize($_FILES['file']['name']);
        $data['MD5sum'] = md5_file($_FILES['file']['name']);
        $data['user_id'] = $_SESSION['id'];

        $package = Package::get('Package', $data['Package']);
        if ($package) $package->update($data); //TODO: remove old versions, replace them or... ?
        else $package = Package::create($data);
        $package->save();
      } else {
        throw new RuntimeException('.deb is corrupted.');
      }

      chdir($cwd);
      if (file_exists($packages_dir . $_FILES['file']['name'])) unlink($packages_dir . $_FILES['file']['name']);
      rename($temp_dir . $_FILES['file']['name'], $packages_dir . $_FILES['file']['name']);

      Utils::generatePackagesFile();

    } catch (RuntimeException $e) {
      $_SESSION['error'] = $e->getMessage();
    }
    chdir($cwd);
      
    $di = new RecursiveDirectoryIterator($temp_dir, FilesystemIterator::SKIP_DOTS);
    $ri = new RecursiveIteratorIterator($di, RecursiveIteratorIterator::CHILD_FIRST);
    foreach ( $ri as $file ) {
      $file->isDir() ?  rmdir($file) : unlink($file);
    }

    Framework::redirect('/admin');
  }
}