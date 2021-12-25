# Dotfiles - Ryan Davis

Configuration files for the following applications:

* NeoVim

## Dockerfile

Included is a Dockerfile that builds my development environment. The following applications are included:

### Editors
* Neovim 0.6.0
### Development
* Ubuntu 22.04
* Node 16
* Python 3.8
* Rust 1.73
* Typescript 4.5
### Applications
* Ripgrep 13.0.0
* Fd-Find 8.3.0
* Pytest 6.2.5
### Linters
* Pytest 2.12.2
* Yamllint 1.26.3
* Shellcheck latest
* Eslint 8.5.0
* Hadolint 2.8.0
### Formatters
* Black 21.12b0
* Prettier 2.5.1
* Stylua 0.11.2
* Rustfmt latest
* Shfmt latest
### LSPs
* Typescript LSP 0.8.0
* Pyright 1.1.199
* Efm Langserver 0.0.38

## How to build
The docker image can be found [here](https://hub.docker.com/repository/docker/ryancraigdavis/dotfiles).
To pull the image run ```docker pull ryancraigdavis/dotfiles:[version]```
