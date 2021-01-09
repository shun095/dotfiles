FROM ubuntu

### Only for local repository
COPY . /root/dotfiles

RUN apt-get update \
    && apt-get install -y curl lsb-release \
    && if [ -f $HOME/dotfiles/install-invoke.sh ]; then \
        echo "dotfiles installer is found."; \
        $HOME/dotfiles/install.sh; \
    else \
        echo "dotfiles installer is not found."; \
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/ishitaku5522/dotfiles/master/install-invoke.sh)"; \
    fi \
    && $HOME/dotfiles/install.sh buildtools \
    && chsh -s /bin/zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
