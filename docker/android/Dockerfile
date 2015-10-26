FROM abarbu/java:8

MAINTAINER Andrei Barbu <andrei@0xab.com>

RUN \
add-apt-repository -y ppa:cwchien/gradle && \
apt-get update && \
apt-get install -y curl lib32stdc++6 lib32z1 lib32ncurses5 lib32bz2-1.0 g++ ant python make gradle

RUN curl http://dl.google.com/android/android-sdk_r24.2-linux.tgz | tar xz --no-same-owner -C /usr/local/
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | /usr/local/android-sdk-linux/tools/android update sdk --filter tools,platform-tools,android-22,build-tools-22.0.1,sys-img-x86_64-android-22,sys-img-armeabi-v7a-android-22,sys-img-x86-android-22,extra-android-m2repository,extra-google-m2repository,extra-android-support --all --no-ui

ENV GRADLE_USER_HOME /src/gradle
VOLUME /src
WORKDIR /src
