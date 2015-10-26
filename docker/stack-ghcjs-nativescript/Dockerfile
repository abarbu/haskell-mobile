FROM fpco/stack-ghcjs-build:lts-3.0

MAINTAINER Andrei Barbu <andrei@0xab.com>

COPY ghcjs.patch /tmp/ghcjs.patch

RUN patch -d /opt/stackage/lts-3/ghcjs/lib/x86_64-linux-0.1.0-7.10.2/ghcjs/ -p0 < /tmp/ghcjs.patch

RUN npm install -g nodemon
COPY compile /usr/bin/compile

VOLUME /src
WORKDIR /src

