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
    echo for zed                            && \
    apt install -y x11-apps                 && \
    apt install -y libasound2               && \
    apt install -y libxkbcommon-tools       && \
    apt install -y libvulkan1               && \
    apt install -y rsync                    && \
    apt install -y git                      && \
    apt install -y gawk                     && \
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

# gawk was needed due to a bug
RUN echo Install Codex   && \
    curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 sh && \
    echo done

RUN echo Install gh   && \
    (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
    && echo done

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
