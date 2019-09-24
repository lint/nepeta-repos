<?php
class Result {
  private $orig = [];
  private $table = "";
  public $data = [];

  function __construct($table, $data = []) {
    $this->table = $table;
    $filteredData = [];
    foreach ($data as $key => $value) {
      if (!is_numeric($key)) {
        $filteredData[$key] = $value;
      }
    }
    $this->data = $filteredData;
    $this->orig = $filteredData;
  }

  public function save() {
    if (array_key_exists("id", $this->orig)) {
      $changes = [];

      foreach ($this->data as $key => $value) {
        if (!array_key_exists($key, $this->orig) || $this->orig[$key] != $value) {
          $changes[$key] = $value;
        }
      }

      $columns = array_reduce(array_keys($changes),
      function ($res, $a) {
        return (($res == '') ? '' : $res . ', ') . '`' . $a . '`=?';
      }, '');

      $q = Framework::get('pdo')->prepare('UPDATE ' . $this->table . ' SET ' . $columns . ' WHERE id=?');
      $values = array_values($changes);
      $values[] = $this->orig['id'];
      $q->execute($values);
    } else {
      $columns = array_reduce(array_keys($this->data),
      function ($res, $a) {
        return (($res == '') ? '' : $res . ', ') . '`' . $a . '`';
      }, '');

      $values = array_reduce(array_keys($this->data),
      function ($res, $a) {
        return (($res == '') ? '' : $res . ', ')  . '?';
      }, '');

      $q = Framework::get('pdo')->prepare('INSERT INTO ' . $this->table . ' (' . $columns . ') VALUES (' . $values . ')');
      $q->execute(array_values($this->data));

      $this->data['id'] = Framework::get('pdo')->lastInsertId();
    }
  }

  public function update($data) {
    foreach ($data as $key => $value) {
      $this->data[$key] = $value;
    }
  }

  public function delete() {
    if (array_key_exists("id", $this->orig)) {
      $q = Framework::get('pdo')->prepare('DELETE FROM ' . $this->table . ' WHERE id=?');
      $q->execute([$this->orig['id']]);
    }
  }

  public function __set($name, $value)
  {
    $this->data[$name] = $value;
  }

  public function __get($name)
  {
    if (array_key_exists($name, $this->data)) {
      return $this->data[$name];
    }

    $trace = debug_backtrace();
    trigger_error(
      'Undefined property via __get(): ' . $name .
      ' in ' . $trace[0]['file'] .
      ' on line ' . $trace[0]['line'],
      E_USER_NOTICE);
    return null;
  }
}