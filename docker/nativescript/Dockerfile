FROM abarbu/node.js:0.12

MAINTAINER Andrei Barbu <andrei@0xab.com>

RUN npm install nativescript -g --unsafe-perm

ENV GRADLE_USER_HOME /src/gradle
VOLUME /src
WORKDIR /src

COPY user-settings.json /root/.local/share/.nativescript-cli/user-settings.json

ADD https://raw.githubusercontent.com/JakeWharton/pidcat/master/pidcat.py /usr/bin/pidcat

RUN chmod +x /usr/bin/pidcat

# If you want an emulator you can use:
#
# RUN dpkg --add-architecture i386
# RUN apt-get update
# RUN apt-get install -y libsdl2-2.0-0:i386
# RUN android create avd -t 1 -n nexus7 -d "Nexus 6" --abi default/armeabi-v7a
