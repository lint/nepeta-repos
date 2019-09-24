<?php
Framework::$router->get('/', ['DefaultController', 'index']);
Framework::$router->get('/depiction/:package', ['PackageController', 'depiction']);

if (Framework::$auth->isLoggedIn()) {
  Framework::$router->get('/admin', ['DefaultController', 'dashboard']);
  Framework::$router->post('/admin/password', ['DefaultController', 'changePassword']);
  Framework::$router->get('/admin/regen', ['MaintenanceController', 'regeneratePackagesFile']);
  Framework::$router->get('/admin/package/:package', ['PackageController', 'view']);
  Framework::$router->get('/admin/package/:package/toggleHidden', ['PackageController', 'updateVisibility']);
  Framework::$router->post('/admin/package/:package/updateDepiction', ['PackageController', 'updateDepiction']);
  Framework::$router->post('/admin/package/:package/delete', ['PackageController', 'delete']);
  Framework::$router->post('/admin/upload', ['PackageController', 'upload']);
} else {
  Framework::$router->get('/admin', ['AuthController', 'login']);
  Framework::$router->post('/admin', ['AuthController', 'loginPost']);
}