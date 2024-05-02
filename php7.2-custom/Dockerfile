# Utiliser l'image officielle PHP 7.0 FPM comme base
FROM php:7.2-fpm
ARG TIMEZONE=Europe/Paris

MAINTAINER Fidel REYES <freyesllerena33@gmail.com>

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

## Install Composer version 1.10.26
#RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#RUN php composer-setup.php --version=1.10.26
#RUN php -r "unlink('composer-setup.php');"
#RUN mv composer.phar /usr/local/bin/composer1

# Install Composer version 2.2.0
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=2.2.0
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Set up Composer global config
RUN mkdir -p /root/.composer && \
    echo "{\"config\": {\"platform\": {\"ext-imagick\": \"7.0.10\"}}}" > /root/.composer/config.json

RUN install-php-extensions \
    gd \
    bz2 \
    calendar \
    exif \
    gettext \
    mysqli \
    pcntl \
    pdo_mysql \
    shmop \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    wddx \
    xsl \
    zip

# Installez les dépendances nécessaires et activez OPcache
RUN docker-php-ext-install opcache


WORKDIR /var/www