FROM ubuntu

### Only for local repository
COPY . /root/dotfiles

RUN apt-get update \
    && apt-get install -y curl lsb-release \
    && if [ -d $HOME/dotfiles ]; then \
        $HOME/dotfiles/install.sh; \
    else \
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/ishitaku5522/dotfiles/master/install.sh)"; \
    fi \
    && $HOME/dotfiles/install.sh buildtools \
    && chsh -s /bin/zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
