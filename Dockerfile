FROM ubuntu:22.04
RUN apt update                              && \
    apt -y upgrade                          && \
    # Some crates need cc so we install build-essential
    apt install -y build-essential          && \
    # The openssl-sys crate needs pkg-config and libssl-dev
    apt install -y pkg-config               && \
    apt install -y libssl-dev               && \
    apt install -y curl                     && \
    apt install -y vim                      && \
    echo done

# Needed for Ubuntu 22.04 but already exists on 25.10
RUN adduser --disabled-password --gecos "" ubuntu

WORKDIR /home/ubuntu
USER ubuntu
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > install.sh
RUN sh install.sh -y && \
    echo done

RUN echo Install crates             && \
    /home/ubuntu/.cargo/bin/cargo install cargo-tarpaulin   && \
    echo done


COPY bashrc /home/ubuntu/.bashrc
USER root
RUN chown ubuntu:ubuntu /home/ubuntu/.bashrc

WORKDIR /opt
