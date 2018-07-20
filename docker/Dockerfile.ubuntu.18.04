FROM ubuntu:18.04

RUN sed -i -e 's,archive.ubuntu.com,ja.archive.ubuntu.com,g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y git rustc cargo cmake libfreetype6-dev libfontconfig1-dev xclip && \
    cargo install cargo-deb
RUN git clone --depth 1 https://github.com/jwilm/alacritty.git

WORKDIR alacritty
RUN sed -i \
        -e 's!^\(version = "0.1.0\)"$!\1-git'`git rev-parse HEAD | cut -c1-8`'+vte"!g' \
        -e 's!^vte = .*$!vte = { git = "https://github.com/amosbird/vte.git", branch= "patch-1" }!g' \
        -e '/^debug =/d' Cargo.toml && \
    cargo deb
