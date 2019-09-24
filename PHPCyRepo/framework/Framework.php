<?php
class Framework {
  private static $variables = [];

  public static $auth = NULL;
  public static $router = NULL;

  public static function initialize() {
    self::$auth = new Auth();
    self::$router = new Router();
  }

  public static function do() {
    $base = dirname($_SERVER['SCRIPT_NAME']);
    $path = substr($_SERVER['REQUEST_URI'], strlen($base));
    $method = $_SERVER['REQUEST_METHOD'];
    
    $route = self::$router->route($method, $path);

    if ($route) {
      call_user_func_array($route['callback'], $route['parameters']);
    } else {
      self::notFound();
    }
  }

  public static function notFound() {
    self::fail(404, 'Not Found');
  }

  public static function redirect($path) {
    $base = dirname($_SERVER['SCRIPT_NAME']);
    header('Location: ' . self::$variables['config']['repo']['url'] . $base . $path);
    exit;
  }

  public static function fail($code, $message = '') {
    http_response_code($code);
    echo $message;
    exit;
  }

  public static function set($key, $value) {
    self::$variables[$key] = $value;
  }

  public static function get($key) {
    return self::$variables[$key];
  }
}