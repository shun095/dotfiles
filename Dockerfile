FROM ubuntu

### Only for local repository
COPY . /root/dotfiles
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8
RUN apt-get update \
    && apt-get install -y curl lsb-release git \
    && if [ -f $HOME/dotfiles/install.sh ]; then \
        $HOME/dotfiles/install.sh; \
    else \
        echo "dotfiles installer is not found. Fetching from the repo."; \
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/shun095/dotfiles/master/install.sh)"; \
    fi \
    && $HOME/dotfiles/install.sh buildtools \
    && chsh -s /bin/zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
