<?php include '_begin.php'; ?>
    <header>
      <h1><?php echo $repo['name']; ?></h1>
    </header>
    <div class="main">
      <h2>Upload</h2>
      <form action="<?php echo $repo['url']; ?>admin/upload" method="post" enctype="multipart/form-data">
        <?php $this->csrf(); ?>
        <input type="file" name="file" />
        <input type="submit" />
      </form>
      <h2>Regen</h2>
      <a href="<?php echo $repo['url']; ?>admin/regen">Regen Packages</a>
      <h2>Packages</h2>
      <?php foreach ($packages as $package) { ?>
        <a href="<?php echo $repo['url']; ?>admin/package/<?php echo $package->Package; ?>">
          <?php echo $package->Package; ?> - <?php echo $package->Name; ?> - <?php echo $package->Version; ?>
        </a>
        <br>
      <?php } ?>
      <h2>Change password</h2>
      <form action="<?php echo $repo['url']; ?>admin/password" method="post">
        <?php $this->csrf(); ?>
        <input type="password" name="password" />
        <input type="submit" />
      </form>
    </div>
<?php include '_end.php'; ?>