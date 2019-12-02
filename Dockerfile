FROM ubuntu:latest

RUN sed -i -e 's,archive.ubuntu.com,ja.archive.ubuntu.com,g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y git cmake libfreetype6-dev libfontconfig1-dev curl python3 libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev && \
    apt-get clean all && \
    curl https://sh.rustup.rs -sSf | sh /dev/stdin -y
ENV PATH /root/.cargo/bin:$PATH
RUN rustup override set stable && \
    rustup update stable && \
    cargo install cargo-deb

#ENV VERSION v0.4.0
ENV COMMIT_ID b115b9038566d6ce0ed56f4a50c428c98e04b51a

RUN mkdir alacritty && cd alacritty && \
    git init && \
    git remote add origin https://github.com/jwilm/alacritty.git && \
    git fetch origin $COMMIT_ID && \
    git reset --hard FETCH_HEAD
WORKDIR alacritty
RUN sed -i -e 's!^\(version = ".\..\..\)"$!\1+vte"!g' alacritty/Cargo.toml && \
        echo 'vte = { git = "https://github.com/buty4649/vte.git", branch= "more-osc-buffer" }' >> Cargo.toml && \
        cargo build --release && cargo deb -p alacritty
