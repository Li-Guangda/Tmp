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
