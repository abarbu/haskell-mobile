FROM ubuntu:14.04

MAINTAINER Andrei Barbu <andrei@0xab.com>

RUN \
  apt-get install -y software-properties-common && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

RUN ln -s /usr/lib/jvm/java-8-oracle /usr/lib/jvm/default-java
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
