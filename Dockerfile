FROM modpreneur/apache-framework:1.0.3


MAINTAINER Martin Kolek <kolek@modpreneur.com>

# Install supervisor and cron
RUN apt-get update && apt-get -y install \
    supervisor \
    cron

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/supervisor-manager.sh /opt/supervisor-manager.sh

RUN echo "modpreneur/necktie:1.0.9" >> /home/versions