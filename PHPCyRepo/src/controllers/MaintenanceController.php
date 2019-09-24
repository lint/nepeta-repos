<?php
class MaintenanceController {
  public static function regeneratePackagesFile() {
    Utils::generatePackagesFile();
    Framework::redirect('/admin');
  }
}