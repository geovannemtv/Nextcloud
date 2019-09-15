FROM debian:9

MAINTAINER "geovanne queiroz"

WORKDIR /var/www/html

# install pre-requisites
RUN apt-get update > /dev/null \
    && apt-get install --assume-yes \
        apache2 \
        cron \
        wget \
        curl \
        git \
        zip \
        unzip \
        gnupg \
        cron  \
        vim \
        apt-transport-https\
        > /dev/null

# install php
RUN curl https://packages.sury.org/php/apt.gpg | apt-key add - \
    && echo "deb https://packages.sury.org/php/ stretch main" \
    | tee /etc/apt/sources.list.d/php7.list \
        && apt-get update > /dev/null \
        && apt-get install --assume-yes \
    php7.2 > /dev/null

#install modules
RUN apt install --assume-yes \
        php7.2-zip \
        php7.2-xml \
        php7.2-gd \
        php7.2-intl \
        php7.2-imagick \
        php7.2-imap \
        php7.2-mailparse \
        php7.2-opcache \
        php7.2-curl \
        php7.2-apcu \
        php7.2-pdo-mysql \
        php7.2-ctype \
        php7.2-json \
        php7.2-mbstring \
        php7.2-memcached \
        php7.2-dom \
        php7.2-xmlreader \
        php7.2-xmlwriter \
        php7.2-SimpleXML > /dev/null
      
#download composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#install nextcloud
RUN wget https://download.nextcloud.com/server/releases/nextcloud-16.0.4.zip
RUN unzip nextcloud-16.0.4.zip  \
    && rm -f nextcloud-16.0.4.zip
   
#permissions apache
RUN rm -f index.html \
    && chown -R www-data:www-data /var/www/html/nextcloud/
RUN chmod -R 755 /var/www/html/nextcloud/

#
COPY ./000-default.conf /etc/apache2/sites-enabled 
#enable module rewrite    
RUN  a2enmod rewrite

#running apache 
CMD apache2ctl -D FOREGROUND
