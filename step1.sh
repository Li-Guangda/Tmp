#!/bin/bash

echo -e "更新源,升级依赖"
apt-get -y update && apt -y upgrade

echo -e "安装常用命令"
apt-get install -y git unzip 

echo -e "安装Docker和Docker-Compose"
apt-get install -y docker.io docker-compose

echo -e "拉取mariadb镜像"
docker pull mariadb:10.9.2

echo -e "构建php-apache-mysql镜像"
docker build -t php-apache-mysql .

echo -e "构建映射目录"
mkdir -vp /data/php-apache/html /data/mysql/data
cp -v php.ini create.sql step2.sh /data/php-apache/html

echo -e "解压discuz论坛文件"
unzip farm-ucenter1.5.zip
mv upload/* /data/php-apache/html
chmod 777 -R /data/php-apache/html

echo -e "运行docker-compose"
docker-compose up

echo -e "进入php容器"
docker exec php /var/www/html/step2.sh

echo -e "准备工作完成！"
