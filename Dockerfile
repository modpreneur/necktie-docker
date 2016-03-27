FROM modpreneur/apache-framework


MAINTAINER Martin Kolek <kolek@modpreneur.com>


RUN apt-get update \
    && docker-php-ext-install pdo_pgsql

# Install apcu, bcmath for rabbit, postfix, composer with plugin for paraller install, clean app folder, clean apache sites
RUN echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt \
    && echo "postfix postfix/mailname string modpreneur.com" >> preseed.txt \
    && debconf-set-selections preseed.txt \
    && DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix \
    && curl -sL https://deb.nodesource.com/setup_5.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g jspm --save-dev \
    && npm install -g less \
    && npm install -g webpack  --save-dev


EXPOSE 22 80 8666 9001 9002