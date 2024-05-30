FROM ubuntu:22.04

RUN apt update && \
    apt install -y \
    bash \
    curl \
    iputils-ping \
    vim\
    git \
    ssh \
    ruby-full \
    python2 \
    make

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

RUN apt clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN npm install -g yarn gulp-cli n
RUN gem install scss-lint

WORKDIR /var/www