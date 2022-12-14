#!/bin/bash


echo -e "\n更新源,升级依赖"
apt-get -y update && apt -y upgrade

echo -e "\n安装常用命令"
apt-get install -y git unzip 

echo -e "\n安装Docker和Docker-Compose"
apt-get install -y docker.io docker-compose

echo -e "\n拉取mariadb镜像"
docker pull mariadb:10.9.2

echo -e "\n构建php-apache-mysql镜像"
docker build -t php-apache-mysql .

echo -e "\n构建映射目录"
mkdir -vp /data/php-apache/html /data/mysql/data
cp -v php.ini create.sql step2.sh /data/php-apache/html

echo -e "\n解压discuz论坛文件"
unzip farm-ucenter1.5.zip
mv upload/* /data/php-apache/html
chmod 777 -R /data/php-apache/html

echo -e "\n运行docker-compose"
docker-compose up -d

echo -e "\n等待5秒，导入数据表"
sleep 5
docker exec php /var/www/html/step2.sh

echo -e "\n准备工作完成！"
