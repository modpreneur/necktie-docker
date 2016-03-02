FROM php:7-apache


MAINTAINER Martin Kolek <kolek@modpreneur.com>


RUN apt-get update && apt-get -y install \
    apt-utils \
    curl \
    git \
    libcurl4-openssl-dev \
    libpq-dev \
    libpq5 \
    zlib1g-dev \
    wget\
    libmcrypt-dev \
    supervisor \
    openssh-server \
    openssh-client \
    nodejs \

    && docker-php-ext-install curl json mbstring opcache pdo_pgsql zip mcrypt


# Install apcu, bcmath for rabbit, postfix, composer with plugin for paraller install, clean app folder, clean apache sites
RUN pecl install -o -f apcu-5.1.3 apcu_bc-beta \
    && rm -rf /tmp/pear \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini \
    && echo "extension=apc.so" >> /usr/local/etc/php/conf.d/apcu.ini \

    && docker-php-ext-configure bcmath \
    && docker-php-ext-install bcmath \

    && echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt \
    && echo "postfix postfix/mailname string modpreneur.com" >> preseed.txt \
    && debconf-set-selections preseed.txt \
    && DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix \

    && curl -sS https://getcomposer.org/installer | php \
    && cp composer.phar /usr/bin/composer \
    && composer global require hirak/prestissimo \

    && rm -rf /var/app/* \

    && rm -rf /etc/apache2/sites-available/* /etc/apache2/sites-enabled/*


WORKDIR /var/app


# Install app
#ADD . /var/app
RUN mkdir web


#set apache
ENV APP_DOCUMENT_ROOT /var/app/web \
 && APACHE_RUN_USER www-data \
 && APACHE_RUN_GROUP www-data \
 && APACHE_LOG_DIR /var/log/apache2 \


ADD docker/php.ini /usr/local/etc/php/
ADD docker/000-default.conf /etc/apache2/sites-available/000-default.conf


# enable apache and mod rewrite, remove parameters, install js
RUN a2ensite 000-default.conf \
    && a2enmod expires \
    && a2enmod rewrite \
    && service apache2 restart \

#    && rm -rf /var/app/app/config/parameters.yml \

    && curl -sL https://deb.nodesource.com/setup_5.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g jspm \
    && npm install -g less

#    && cd web/js \
#    && jspm config registries.github.auth "dmxjZWs6NjgwOGM3MzVkZDkwMDZjNjBiOWRmM2RjYjc5MTI5OGUwMjkxNjgzZg==" \
#    && jspm install -y \
#    && nodejs ./scripts/buildBundles.js


COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


EXPOSE 22 80 8666 9001 9002
#
#
#RUN chmod +x entrypoint.sh
#ENTRYPOINT ["sh", "entrypoint.sh", "service postfix start"]
