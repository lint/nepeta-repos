<?php include '_begin.php'; ?>
    <header>
      <h1><?php echo $repo['name']; ?></h1>
      <h2><?php echo $package->Name; ?></h2>
    </header>
    <div class="main">
      <a href="<?php echo $repo['url']; ?>admin">Back</a>
      <div class="description">
        <div>
          <h2>Info</h2>
          <table>
            <?php foreach ($package->data as $key => $value) { if (!is_numeric($key) && !empty($value)) { ?>
            <tr>
              <td><?php echo $key; ?></td>
              <td><?php echo $value; ?></td>
            </tr>
            <?php } } ?>
          </table>
          <?php if ($package->hidden) { ?>
          <b>Package is hidden.</b> <a href="<?php echo $repo['url']; ?>admin/package/<?php echo $package->Package; ?>/toggleHidden">Unhide</a>
          <?php } else { ?>
          <b>Package is visible.</b> <a href="<?php echo $repo['url']; ?>admin/package/<?php echo $package->Package; ?>/toggleHidden">Hide</a>
          <?php } ?>
        </div>
        <div>
          <h2>Depiction</h2>
          <form action="<?php echo $repo['url']; ?>admin/package/<?php echo $package->Package; ?>/updateDepiction" method="POST">
          <?php $this->csrf(); ?>
          <textarea rows=15 cols=40 name="depiction"><?php if (!empty($package->data['Depiction'])) {
            echo $package->Depiction;
          } else {
            echo $package->Description;
          }?></textarea><br>
          <input type="submit" />
          </form>
        </div>
        <div>
          <h2>Delete</h2>
          <b>WARNING! This is not reversible!</b>
          <form action="<?php echo $repo['url']; ?>admin/package/<?php echo $package->Package; ?>/delete" method="POST">
            <?php $this->csrf(); ?>
            <input type="submit" value="Delete">
          </form>
        </div>
      </div>
    </div>
<?php include '_end.php'; ?>