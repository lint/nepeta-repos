<?php include '_begin.php'; ?>
    <header>
      <h1><?php echo $repo['name']; ?></h1>
      <h2>Log in</h2>
    </header>
    <div class="main">
      <form method="POST">
        <input type="text" name="username" />
        <input type="password" name="password" />
        <input type="submit" value="" />
      </form>
    </div>
<?php include '_end.php'; ?>