FROM modpreneur/apache-framework:0.6


MAINTAINER Martin Kolek <kolek@modpreneur.com>

# Install supervisor, postfix, composer with plugin for paraller install, clean app folder, clean apache sites
RUN apt-get update && apt-get -y install \
    supervisor \
    cron \
    && echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt \
    && echo "postfix postfix/mailname string modpreneur.com" >> preseed.txt \
    && debconf-set-selections preseed.txt \
    && DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g less \
    && npm install -g webpack  --save-dev \
    && npm install -g uglifycss

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/supervisor-manager.sh /opt/supervisor-manager.sh

RUN echo "modpreneur/necktie:1.0" >> /home/versions