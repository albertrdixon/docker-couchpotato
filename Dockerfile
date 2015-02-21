FROM debian:jessie
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends --force-yes \
    python git-core supervisor ca-certificates \
    unar unzip locales curl

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

RUN curl -#kL https://github.com/jwilder/dockerize/releases/download/v0.0.2/dockerize-linux-amd64-v0.0.2.tar.gz |\
    tar xvz -C /usr/local/bin

RUN git clone --branch master --single-branch \
    git://github.com/RuudBurger/CouchPotatoServer.git /couchpotato

ADD docker-* /usr/local/bin/
ADD configs /templates
RUN mkdir /data && \
    chmod a+rx /usr/local/bin/*

WORKDIR /couchpotato
ENTRYPOINT ["docker-entry"]
EXPOSE 5050

ENV SUPERVISOR_LOG_LEVEL INFO
ENV CP_DATA_DIR          /data
ENV CP_CONFIG            /data/settings.conf
ENV CP_PID_FILE          /data/couchpotato.pid