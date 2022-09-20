<?php
  $link = mysqli_connect('mariadb', 'root', '123');
  if ($link)
    echo "Connection ok!";
  else
    echo "Connection error!";
?>
