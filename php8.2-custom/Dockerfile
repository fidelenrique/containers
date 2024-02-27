FROM php:8.2-fpm
ARG TIMEZONE=Europe/Paris

MAINTAINER Fidel REYES <freyesllerena33@gmail.com>

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN docker-php-ext-install opcache

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
    zip \
    unzip \
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

## interface PDF not working
#RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb \
# && dpkg -i wkhtmltox_0.12.5-1.stretch_amd64.deb \
# && apt install -y -f \
# && rm wkhtmltox_0.12.5-1.stretch_amd64.deb

# Composer 1
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=1.10.26
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer1

# Composer 2
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --version=2.4.1
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash
RUN apt update && apt install symfony-cli -y

RUN apt install git -y
RUN apt -y install make

WORKDIR /var/www
