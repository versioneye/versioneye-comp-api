FROM        versioneye/ruby-base:2.3.0
MAINTAINER  Robert Reiz <reiz@versioneye.com>

ADD . /app

RUN apt-get update && apt-get install -y supervisor; \
    cp /app/supervisord.conf /etc/supervisord.conf; \
    cd /app/ && bundle install;

EXPOSE 8080

CMD /usr/bin/supervisord -c /etc/supervisord.conf
