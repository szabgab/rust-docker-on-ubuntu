FROM ubuntu:26.04
RUN apt update                              && \
    apt -y upgrade                          && \
    # Some crates need cc so we install build-essential
    apt install -y build-essential          && \
    # The openssl-sys crate needs pkg-config and libssl-dev
    apt install -y pkg-config               && \
    apt install -y libssl-dev               && \
    apt install -y curl                     && \
    apt install -y vim                      && \
    echo for zed                            && \
    apt install -y x11-apps                 && \
    apt install -y libxkbcommon-tools       && \
    apt install -y libvulkan1               && \
    apt install -y rsync                    && \
    apt install -y git                      && \
    apt install -y gawk                     && \
    apt install -y bubblewrap               && \
    echo done

# Needed for Ubuntu 22.04 but already exists on 25.10
# RUN adduser --disabled-password --gecos "" ubuntu

WORKDIR /home/ubuntu
USER ubuntu
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > install.sh
RUN sh install.sh -y && \
    echo done

RUN echo Install crates             && \
    /home/ubuntu/.cargo/bin/cargo install cargo-tarpaulin   && \
    echo done

# gawk was needed due to a bug
# codex asked for bubblewrap to be installed.
# Try to make sure the codex installation is inside the image
# while allowing the user to put the auth.json and session data on the host volume.
RUN echo Install Codex   && \
    curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh && \
    mv ~/.codex ~/installed-codex && \
    rm -f .local/bin/codex        && \
    ln -s /home/ubuntu/installed-codex/packages/standalone/releases/$(ls -1 /home/ubuntu/installed-codex/packages/standalone/releases/)/bin/codex .local/bin/codex && \
    echo done

RUN echo Install Antigravity   && \
    curl -fsSL https://antigravity.google/cli/install.sh | bash  && \
    echo done

RUN echo Install GitHub co-pilot CLI   && \
    curl -fsSL https://gh.io/copilot-install | bash  && \
    echo done

COPY bashrc /home/ubuntu/.bashrc
USER root
RUN chown ubuntu:ubuntu /home/ubuntu/.bashrc

WORKDIR /opt
