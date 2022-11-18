FROM php:7.4-fpm
ARG TIMEZONE=Europe/Paris

MAINTAINER Stéphane RATHGEBER <stephane.kiora@gmail.com>

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod uga+x /usr/local/bin/install-php-extensions && sync

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && apt-get install -y \
    pdftk \
    zlib1g-dev \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    libxext6 \
    libxrender1 \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libmemcached-dev \
    libpq-dev \
    wget \
    ghostscript \
    xfonts-base \
    xfonts-75dpi \
    fontconfig \
    build-essential \
    libmagickwand-dev \
    && apt-get clean all

RUN pecl install imagick \
 && docker-php-ext-enable imagick

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
 && printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini \
 && "date"


RUN install-php-extensions \
    bcmath \
    gd \
    intl \
    memcached\
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    pcntl \
    soap \
    zip \
    xdebug \
    amqp \
    redis

# install xdebug
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
 && dpkg -i wkhtmltox_0.12.5-1.stretch_amd64.deb \
 && apt install -y -f \
 && rm wkhtmltox_0.12.5-1.stretch_amd64.deb

#https://blog.rkl.io/en/blog/docker-based-php-7-symfony-4-development-environment
# disbale xdebug for composer
#RUN mkdir /usr/local/etc/php/conf.d.noxdebug \
#  && ln -s /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d.noxdebug/ \
#  && unlink /usr/local/etc/php/conf.d.noxdebug/docker-php-ext-xdebug.ini \
#  && echo "alias composer='PHP_INI_SCAN_DIR=/etc/php.d.noxdebug/ /usr/local/bin/composer'" >> /etc/bashrc

# Composer 1
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=1.10.26
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Composer 2
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=2.4.1
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer2

RUN apt update && apt install git -y

WORKDIR /var/www
