FROM alpine:3.2
MAINTAINER Albert Dixon <albert.dixon@schange.com>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update
RUN apk add bash python ca-certificates \
    git unrar py-openssl supervisor

ADD https://github.com/albertrdixon/tmplnator/releases/download/v2.2.0/t2-linux.tgz /t2.tgz
RUN tar xvzf /t2.tgz -C /usr/local \
    && ln -s /usr/local/bin/t2-linux /usr/local/bin/t2 \
    && rm -f /t2.tgz

ADD https://github.com/albertrdixon/escarole/releases/download/v0.1.1/escarole-linux.tgz /es.tgz
RUN tar xvzf /es.tgz -C /usr/local \
    && ln -s /usr/local/bin/escarole-linux /usr/local/bin/escarole \
    && rm -f /es.tgz

RUN git clone -v --depth 1 git://github.com/RuudBurger/CouchPotatoServer.git /couchpotato

ADD bashrc /root/.bashrc
ADD configs /templates
ADD scripts/* /usr/local/bin/
RUN mkdir /data &&\
    chown root:root /usr/local/bin/* &&\
    chmod a+rx /usr/local/bin/*

WORKDIR /couchpotato
ENTRYPOINT ["docker-entry"]
CMD ["docker-start"]
EXPOSE 5050

ENV PATH                 /usr/local/bin:$PATH
ENV OPEN_FILE_LIMIT      32768
ENV SUPERVISOR_LOG_LEVEL INFO
ENV UPDATE_INTERVAL      4h
ENV COUCHPOTATO_HOME     /couchpotato
ENV COUCHPOTATO_CHANNEL  master
ENV CP_DATA_DIR          /data
ENV CP_CONFIG            /data/settings.conf
ENV CP_PID_FILE          /data/couchpotato.pid
