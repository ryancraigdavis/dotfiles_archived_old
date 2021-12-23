# syntax = docker/dockerfile:1.0-experimental
FROM https://registry.hub.docker.com/ubuntu:focal-20211006
MAINTAINER ryancraigdavis "http:www.ryancdavis.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip
