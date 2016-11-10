FROM modpreneur/apache-framework:1.0.1


MAINTAINER Martin Kolek <kolek@modpreneur.com>

# Install supervisor, composer with plugin for paraller install, clean app folder, clean apache sites
RUN apt-get update && apt-get -y install \
    supervisor \
    cron

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/supervisor-manager.sh /opt/supervisor-manager.sh

RUN echo "modpreneur/necktie:1.0.7" >> /home/versions