# Dockerfile with Oracle Java 8. Scala 2.11.8 and scala-sbt 0.13.13
# Based on Ubuntu Xenial
# Adapted from https://github.com/dockerfile/java
# Maintained by Jozko Skrablin

# Pull base image.
FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.11.8
ENV SCALA_SBT_VERSION 0.13.13
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8

# Add Oracle Java 8 PPA sources and upgrade the base image
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" >> /etc/apt/sources.list.d/webupd8team-ubuntu-java-xenial.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xc2518248eea14886

# Install Oracle Java 8 and remove installer files
RUN apt-get -qy update && apt-get -qy upgrade && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get install -qy oracle-java8-installer && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    apt-get -y clean && apt-get -y autoclean && \
    rm -rf /var/lib/apt/lists/*

# Install Scala and remove scala javadoc to keep image small
RUN wget http://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.deb -O /tmp/scala-${SCALA_VERSION}.deb && \
    dpkg -i /tmp/scala-${SCALA_VERSION}.deb && \
    rm -f /tmp/scala-${SCALA_VERSION}.deb && \
    rm -rf /usr/share/doc/scala

# Get and install scala-sbt from deb file
RUN wget https://dl.bintray.com/sbt/debian/sbt-${SCALA_SBT_VERSION}.deb -O /tmp/sbt-${SCALA_SBT_VERSION}.deb && \
    dpkg -i /tmp/sbt-${SCALA_SBT_VERSION}.deb && \
    rm -f /tmp/sbt-${SCALA_SBT_VERSION}.deb

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \
  SCALA_HOME=/usr/share/scala

RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/java-8-oracle/bin/java" 1081 && \
  update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/java-8-oracle/bin/javac" 1081 && \
  update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/java-8-oracle/bin/javaws" 1081
