FROM ubuntu:latest

RUN sed -i -e 's,archive.ubuntu.com,ja.archive.ubuntu.com,g' /etc/apt/sources.list
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git cmake libfreetype6-dev libfontconfig1-dev curl python3 libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libxkbcommon-dev && \
    apt-get clean all && \
    curl https://sh.rustup.rs -sSf | sh /dev/stdin -y
ENV PATH /root/.cargo/bin:$PATH
RUN rustup override set stable && \
    rustup update stable && \
    cargo install cargo-deb

ENV VERSION v0.10.1

RUN mkdir alacritty && cd alacritty && \
    git init && \
    git remote add origin https://github.com/jwilm/alacritty.git && \
    git fetch origin $VERSION && \
    git reset --hard FETCH_HEAD
WORKDIR alacritty
COPY metadata.toml metadata.toml
RUN cat metadata.toml >> alacritty/Cargo.toml && \
    cargo build --release && \
    cargo deb -p alacritty
