FROM debian:jessie
MAINTAINER Albert Dixon <albert@timelinelabs.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends --force-yes \
    python git-core supervisor ca-certificates \
    unrar-free unar unzip locales
RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

RUN git clone --branch master --single-branch \
    git://github.com/RuudBurger/CouchPotatoServer.git /couchpotatoserver

ADD docker-start /usr/local/bin/
ADD supervisord/* /etc/supervisor/conf.d/
RUN mkdir /data && \
    chmod a+rx /usr/local/bin/*

WORKDIR /couchpotatoserver
ENTRYPOINT ["docker-start"]
EXPOSE 5050

ENV CP_DATA_DIR   /data
ENV CP_CONFIG     $CP_DATA_DIR/settings.conf
ENV CP_PID_FILE   $CP_DATA_DIR/couchpotato.pid