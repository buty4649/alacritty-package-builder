FROM ubuntu:latest

RUN sed -i -e 's,archive.ubuntu.com,ja.archive.ubuntu.com,g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y git cmake libfreetype6-dev libfontconfig1-dev xclip curl && \
    apt-get clean all && \
    curl https://sh.rustup.rs -sSf | sh /dev/stdin -y
ENV PATH /root/.cargo/bin:$PATH
RUN rustup override set stable && \
    rustup update stable && \
    cargo install cargo-deb

ENV VERSION v0.2.9

RUN git clone --depth 1 --branch $VERSION https://github.com/jwilm/alacritty.git
WORKDIR alacritty
RUN sed -i \
        -e 's!^\(version = ".\..\..\)"$!\1+vte"!g' \
        -e 's!^vte = .*$!vte = { git = "https://github.com/amosbird/vte.git", branch= "patch-1" }!g' \
        -e '/^debug =/d' Cargo.toml && \
        cargo build --release && cargo deb
