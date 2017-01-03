#
# Dockerfile with Oracle Java 8. Scala 2.11.8 and scala-sbt 0.13.13
# Based on Ubuntu Xenial
# Adapted from https://github.com/dockerfile/java
# Maintained by Jozko Skrablin
#

# Pull base image.
FROM ubuntu:xenial

# Add Oracle Java 8 PPA sources and upgrade the base image
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" >> /etc/apt/sources.list.d/webupd8team-ubuntu-java-xenial.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xc2518248eea14886

# Install Oracle Java 8 and remove installer files
RUN apt-get -y update && apt-get -y upgrade && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    apt-get -y clean && apt-get -y autoclean && \
    rm -rf /var/lib/apt/lists/*

# Install Scala and remove scala javadoc to keep image small
RUN wget http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.deb -O /tmp/scala-2.11.8.deb && \
    dpkg -i /tmp/scala-2.11.8.deb && \
    rm -f /tmp/scala-2.11.8.deb && \
    rm -rf /usr/share/doc/scala

# Get and install scala-sbt from deb file
RUN wget https://dl.bintray.com/sbt/debian/sbt-0.13.13.deb -O /tmp/sbt-0.13.13.deb && \
    dpkg -i /tmp/sbt-0.13.13.deb && \
    rm -f /tmp/sbt-0.13.13.deb


# Define commonly used JAVA_HOME variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \
  SCALA_HOME=/usr/share/scala
