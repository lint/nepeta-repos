<?php
class AuthController {
  public static function login() {
    $view = new View('login.php');
    $view->render(['repo' => Framework::get('config')['repo']]);
  }

  public static function loginPost() {
    $view = new View('login.php');

    if (!empty($_POST['username']) && !empty($_POST['password'])) {
      $user = User::get('username', $_POST['username']);

      if ($user && !empty($user->data['password']) && password_verify($_POST['password'], $user->password)) {
        Framework::$auth->authenticate($user);
        Framework::redirect('/admin');
      } else {
        $view->errors = ['Invalid username or password.'];
      }
    }
    
    $view->render(['repo' => Framework::get('config')['repo']]);
  }

  public static function logout() {
    Framework::$auth->deauthenticate();
    Framework::redirect('/');
  }
}