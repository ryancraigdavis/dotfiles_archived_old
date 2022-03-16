FROM ubuntu:focal-20211006
LABEL maintainer = "Ryan Davis - http:www.ryancdavis.com"

ENV DEBIAN_FRONTEND=noninteractive

ARG GO_VERSION=17.5
ARG NODE_VERSION=16
ARG NVIM_VERSION=0.6.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y git \
  shellcheck \
  curl \
  ninja-build \
  gettext \
  libtool \
  libtool-bin \
  autoconf \
  automake \
  cmake \
  g++ \
  pkg-config \
  unzip \
  doxygen \
  && mkdir "$HOME/.config" \
  && git clone https://github.com/ryancraigdavis/dotfiles $HOME/dotfiles \
  && mv "$HOME/dotfiles/nvim" "$HOME/.config" \
    # NeoVim
  && git clone https://github.com/neovim/neovim $HOME/neovim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /root/neovim
RUN git checkout tags/v${NVIM_VERSION} && make && make install \


  # Nodejs Install
  && curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o nodesource_setup.sh \
  && bash nodesource_setup.sh \
  && apt-get -y --no-install-recommends install nodejs \

  # Python3 Install
  && apt-get install -y --no-install-recommends python3-pip python3-dev
WORKDIR /usr/local/bin
RUN ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir --upgrade pip
WORKDIR /root

  # Go Install
RUN curl -OL https://golang.org/dl/go1.${GO_VERSION}.linux-amd64.tar.gz \
  && tar -C /usr/local -xvf go1.${GO_VERSION}.linux-amd64.tar.gz \
  && rm -rf go1.${GO_VERSION}.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/usr/local/go"

  # Rust Install
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

  # Python Packages
RUN pip install --no-cache-dir pytest==6.2.5 \
  yamllint==1.26.3 \
  pylint==2.12.2 \
  black==21.12b0 \

  # Rust Packages
  && cargo install --version 0.11.2 stylua \
  && cargo install --version 13.0.0 ripgrep \
  && cargo install --version 8.3.0 fd-find \
  && rustup component add rustfmt \

  # NPM Packages - linters and lsp servers
  && npm install -g pyright@1.1.199 \
  typescript@4.5 \
  typescript-language-server@0.8.0 \
  eslint@8.5.0 \
  prettier@2.5.1 \

  && go install github.com/mattn/efm-langserver@v0.0.38 \
  && go install mvdan.cc/sh/v3/cmd/shfmt@latest \
  && go install github.com/jesseduffield/lazygit@latest \
  && curl -o /usr/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.8.0/hadolint-Linux-x86_64 \
  && chmod +x /usr/bin/hadolint \

  # Package Cleanup
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /usr/local/go \

ENTRYPOINT ["/bin/bash"]
