<?php include '_begin.php'; ?>
    <header>
      <h1><?php echo $repo['name']; ?></h1>
    </header>
    <div class="main">
      <a href="cydia://url/https://cydia.saurik.com/api/share#?source=<?php echo $repo['url']; ?>repo/" class="button">Add to Cydia</a>
      <div class="description">
        <?php echo $repo['description']; ?>
      </div>
    </div>
<?php include '_end.php'; ?>