FROM php:5.6.40-apache
RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    sed -i s@/security.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    apt-get clean && \
    apt-get update && \
    apt-get install -y libfreetype6-dev \
                   libjpeg62-turbo-dev \
                   libpng-dev \
                   libxml2-dev \
                   libcurl4-gnutls-dev \
                   mariadb-client
RUN docker-php-ext-install -j $(nproc) mysql mysqli pdo_mysql\
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j $(nproc) gd \
    && /var/www/html/step2.sh
