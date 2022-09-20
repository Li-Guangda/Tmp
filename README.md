## 0.以root身份登录Centos

## 1.更新升级系统
```
apt -y update && apt -y upgrade
```

## 2.安装常用命令
```
apt install -y git unzip 
```

## 3.安装docker
```
apt install -y docker.io docker-compose
```

## 4.下载mariadb镜像
```
docker pull mariadb:10.9.2
```

## 5.构建php-apache-mysql镜像
首先，在任意目录下，创建一个名为Dockerfile的文件，其内容如下：
```docker
FROM php:5.6.40-apache
RUN apt update && \
    apt install -y libfreetype6-dev \
                   libjpeg62-turbo-dev \
                   libpng-dev \
                   libxml2-dev \
                   libcurl4-gnutls-dev \
                   mariadb-client
RUN docker-php-ext-install -j $(nproc) mysql mysqli pdo_mysql\
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j $(nproc) gd
```
保存，在同一目录下接着运行命令：
```
docker build -t php-apache-mysql .
```

## 6.构建映射目录，安装discuz论坛
```
mkdir -p /data/php-apache/html /data/mysql/data
unzip farm-ucenter1.5.zip
mv upload/* /data/php-apache/html
chmod 777 -R /data/php-apache/html
```

## 7.构建docker-compose.yaml
在同一目录下，创建docker-compose.yaml文件，其内容如下：
```
version: '3'
services:
  apache:
    image: php-apache-mysql
    container_name: php
    restart: always
    ports:
    - 80:80
    - 443:443
    volumes:
    - /data/php-apache/html:/var/www/html:rw
    - /data/php-apache/php.ini:/usr/local/etc/php/php.ini:rw
    links:
    - mariadb
  mariadb:
    restart: always
    image: mariadb:10.9.2
    container_name: mariadb
    environment:
    - "MARIADB_ROOT_PASSWORD=123"
    - "TZ=Asia/Shanghai"
    ports:
    # 使用宿主机的3306端口映射到容器的3306端口
    # 宿主机：容器
    - 3306:3306
    volumes:
    # 持久化 mysql
    - /data/mysql/data:/var/lib/mysql/:rw
```
在同一目录运行命令：
```
docker-compose up -d
```

## 8.创建数据库数据
首先进入php容器：
```
docker exec -it php /bin/bash
```
运行mariadb客户端cli:
```
mysql -h mariadb -u root -p123
```
创建一个名为qqfarm的数据库：
```
create database qqfarm;
```
更改权限：
```
grant all on qqfarm.* to 'zhang'@'%' identified by '123';
```
退出,此时返回到php容器中的shell：
```
quit
```
执行sql语句：
```
mysql -h mariadb -u root -p123 qqfarm < /var/www/html/qqfarm.sql
```
退出，此时返回到主机的shell:
```
exit
```
