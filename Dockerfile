# syntax = docker/dockerfile:1.0-experimental
FROM https://registry.hub.docker.com/ubuntu:focal-20211006
LABEL maintainer = "Ryan Davis - http:www.ryancdavis.com"

ENV DEBIAN_FRONTEND=noninteractive

ARG GO_VERSION=17.5
ARG NODE_VERSION=16

RUN apt-get install git \
  shellcheck \
  wget \
  curl

RUN cd ~/ && mkdir .config && cd .config
RUN git clone https://github.com/ryancraigdavis/dotfiles
RUN mv ~/dotfiles/nvim ~/.config

RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Nodejs Install
# RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o nodesource_setup.sh \
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh \
  && bash nodesource_setup.sh \
  && apt install nodejs \
  npm

# Python3 Install
RUN apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip \
  && cd ~/

# Go Install
# RUN curl -OL https://golang.org/dl/go1.${GO_VERSION}.linux-amd64.tar.gz \
#   && tar -C /usr/local -xvf go1.${GO_VERSION}.linux-amd64.tar.gz \
RUN curl -OL https://golang.org/dl/go1.17.5.linux-amd64.tar.gz \
  && tar -C /usr/local -xvf go1.17.5.linux-amd64.tar.gz \
  && export PATH=$PATH:/usr/local/go/bin \
  && export GOPATH=/usr/local/go \
  && rm -rf go1.17.5.linux-amd64.tar.gz 

# Python Packages
RUN pip install --no-cache-dir \
  pytest \
  yamllint \
  pylint

# NPM Packages - linters and lsp servers
RUN npm install -g pyright \
  typescript \
  typescript-language-server \
  eslint \
  && go install github.com/mattn/efm-langserver@latest

# NeoVim Prereqs
RUN apt-get install ninja-build \
  gettext \
  libtool \
  libtool-bin \
  autoconf \
  automake \
  cmake \
  g++ \
  pkg-config \
  unzip \
  doxygen
RUN git clone https://github.com/neovim/neovim
RUN cd neovim
RUN git checkout tags/v0.6.0
RUN make
RUN make install && cd ~/

