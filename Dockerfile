# syntax = docker/dockerfile:1.0-experimental
FROM https://registry.hub.docker.com/ubuntu:focal-20211006
MAINTAINER ryancraigdavis "http:www.ryancdavis.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt install git

# Python3 Install
RUN apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

# NeoVim Prereqs
RUN apt-get install ninja-build \
  && gettext \
  && libtool \
  && libtool-bin \
  && autoconf \
  && automake \
  && cmake \
  && g++ \
  && pkg-config \
  && unzip \
  && curl \
  && doxygen
RUN git clone https://github.com/neovim/neovim
RUN cd neovim
RUN git checkout tags/v0.6.0
RUN make
RUN make install && cd ~/

RUN cd ~/ && mkdir .config && cd .config
RUN git clone https://github.com/ryancraigdavis/dotfiles
RUN mv ~/dotfiles/nvim ~/.config

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim



