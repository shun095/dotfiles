FROM ubuntu

RUN apt-get update
RUN apt-get install -y curl lsb-release

### For local repository
COPY . /root/dotfiles

RUN if [ -d $HOME/dotfiles ]; then \
        $HOME/dotfiles/install.sh; \
    else \
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/ishitaku5522/dotfiles/master/install.sh)"; \
    fi \
    && $HOME/dotfiles/install.sh buildtools \
    && chsh -s /bin/zsh

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
