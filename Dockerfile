FROM modpreneur/apache-framework:1.0.1


MAINTAINER Martin Kolek <kolek@modpreneur.com>

# Install supervisor, postfix, composer with plugin for paraller install, clean app folder, clean apache sites
RUN apt-get update && apt-get -y install \
    supervisor \
    cron \
    && echo "postfix postfix/main_mailer_type string Internet site" > preseed.txt \
    && echo "postfix postfix/mailname string modpreneur.com" >> preseed.txt \
    && debconf-set-selections preseed.txt \
    && DEBIAN_FRONTEND=noninteractive apt-get install -q -y postfix

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/supervisor-manager.sh /opt/supervisor-manager.sh

RUN echo "modpreneur/necktie:1.0.6" >> /home/versions