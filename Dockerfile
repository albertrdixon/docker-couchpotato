FROM alpine:3.3
MAINTAINER Albert Dixon <albert@dixon.rocks>

ENTRYPOINT ["tini", "--", "/sbin/entry"]
CMD ["/sbin/start"]
VOLUME ["/data"]
EXPOSE 5050

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    OPEN_FILE_LIMIT=32768 \
    UPDATE_INTERVAL=1h \
    CP_CONFIG=/data/settings.conf \
    CP_DATA_DIR=/data \
    CP_GID=7000 \
    CP_HOME=/src/couchpotato \
    CP_PID_FILE=/data/couchpotato.pid \
    CP_UID=7000 \
    CP_CHANNEL=master

COPY ["entry", "start", "/sbin/"]
COPY escarole.yml /
ADD https://github.com/albertrdixon/escarole/releases/download/v0.2.3/escarole-linux.tgz /es.tgz
RUN tar xvzf /es.tgz -C /bin \
    && rm -rf /es.tgz \
    && chmod +rx /sbin/entry /sbin/start \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --update --purge \
        ca-certificates \
        git \
        py-html5lib \
        py-lxml \
        py-openssl \
        python \
        unrar \
        tini
