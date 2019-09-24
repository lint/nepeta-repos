<?php
class Router {
  private $routes = [];

  private function handle($method, $route, $callback) {
    $regex = '|^' . preg_replace_callback('/(\/:([.\w]+))/', function ($matches) {
      return '/(.*?)';
    }, $route) . '$|i';
    $this->routes[] = [
      'method' => $method,
      'route' => $route,
      'regex' => $regex,
      'callback' => $callback
    ];
  }

  public function route($method, $path) {
    $path = trim($path, " \t\n\r\0\x0B\\\/");
    $path = str_replace("\\", '/', $path);
    $path = '/' . $path;
    
    foreach ($this->routes as $route) {
      $matches = [];
      if (($route['method'] == $method || $route['method'] == 'ALL') && preg_match($route['regex'], $path, $matches) === 1) {
        array_shift($matches);
        $route['parameters'] = $matches;
        return $route;
      }
    }

    return NULL;
  }

  public function __call($name, $arguments) {
    if (count($arguments) != 2) throw new Exception('This function requires exactly 2 arguments.');
    $this->handle(strtoupper($name), $arguments[0], $arguments[1]);
  }
}