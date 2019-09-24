<?php include '_begin.php'; ?>
    <header>
      <h1><?php echo $repo['name']; ?></h1>
      <h2><?php echo $package->Name; ?></h2>
    </header>
    <div class="main">
      <div class="description">
        <?php if (!empty($package->Depiction)) {
          echo $package->Depiction;
        } else {
          echo $package->Description;
        }?>
      </div>
    </div>
<?php include '_end.php'; ?>