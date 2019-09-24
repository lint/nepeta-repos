<?php
class Auth {
  function __construct() {
    session_start();
  }

  public function authenticate($user) {
    $_SESSION['auth'] = $user->auth;
    $_SESSION['username'] = $user->username;
    $_SESSION['id'] = $user->id;
    $_SESSION['token'] = bin2hex(random_bytes(32));
  }

  public function getUser() {
    return User::get('id', $_SESSION['id']);
  }

  public function deauthenticate() {
    session_destroy();
  }

  public function isLoggedIn() {
    return !empty($_SESSION['auth']) && $_SESSION['auth']>0;
  }

  public function getCsrfToken() {
    return $_SESSION['token'];
  }

  public function isSuperuser() {
    return $_SESSION['auth']==1;
  }

  public function mayOwnPackages() {
    return $_SESSION['auth']<10 && $_SESSION['auth']>0;
  }
}