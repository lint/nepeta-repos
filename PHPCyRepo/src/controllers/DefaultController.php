<?php
class DefaultController {
  public static function index() {
    $view = new View('index.php');
    $view->render(['repo' => Framework::get('config')['repo']]);
  }

  public static function dashboard() {
    $view = new View('admin.php');

    if (isset($_SESSION['error'])) {
      $view->errors = [$_SESSION['error']];
      unset($_SESSION['error']);
    }
  
    $view->render(['repo' => Framework::get('config')['repo'], 'packages' => Package::all()]);
  }

  public static function changePassword() {
    Utils::checkCsrfToken();

    $user = Framework::$auth->getUser();
    $user->password = password_hash($_POST['password'], PASSWORD_DEFAULT);
    $user->save();

    Framework::redirect('/admin');
  }
}