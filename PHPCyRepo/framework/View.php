<?php
class View {
  private $variables = [];
  private $path = "";

  function __construct($path) {
    $this->path = $path;
  }

  public function __set($name, $value)
  {
    $this->variables[$name] = $value;
  }

  public function __get($name)
  {
    if (array_key_exists($name, $this->variables)) {
      return $this->variables[$name];
    }

    $trace = debug_backtrace();
    trigger_error(
      'Undefined property via __get(): ' . $name .
      ' in ' . $trace[0]['file'] .
      ' on line ' . $trace[0]['line'],
      E_USER_NOTICE);
    return null;
  }

  public function csrf() {
    ?>
    <input type="hidden" name="csrf_token" value="<?php echo Framework::$auth->getCsrfToken(); ?>" />
    <?php
  }

  public function render($parameters = []) {
    foreach ($this->variables as $key => $value) {
      ${$key} = $value;
    }

    foreach ($parameters as $key => $value) {
      ${$key} = $value;
    }

    require 'views/' . $this->path;
  }
}