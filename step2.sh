#!/bin/bash

mysql -h mariadb -u root -p123 < /var/www/html/create.sql
mysql -h mariadb -u root -p123 qqfarm < /var/www/html/qqfarm.sql
