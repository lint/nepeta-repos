<?php
abstract class Model {
  protected static $table = NULL;

  public static function create($data) {
    return new Result(static::$table, $data);
  }

  public static function get($field, $value) {
    $q = Framework::get('pdo')->prepare('SELECT * FROM ' . static::$table . ' WHERE ' . $field . '=?');
    $q->execute([$value]);
    $r = $q->fetch();
    if ($r && is_array($r)) {
      return new Result(static::$table, $r);
    } else {
      return null;
    }
  }

  public static function all($where = NULL, $values = []) {
    $queryWhere = ($where) ? ' WHERE ' . $where : '';
    $q = Framework::get('pdo')->prepare('SELECT * FROM ' . static::$table . $queryWhere . ';');
    $q->execute($values);
    $rows = $q->fetchAll();
    return array_map(function ($row) {
      return new Result(static::$table, $row);
    }, $rows);
  }
}