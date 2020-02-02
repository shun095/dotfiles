FROM ubuntu

### For local repository
# COPY . $HOME/dotfiles

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl lsb-release && \
    if [ ! -d "$HOME/dotfiles" ]; then \
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/ishitaku5522/dotfiles/master/install.sh)"; \
    else \
        $HOME/dotfiles/install.sh; \
    fi && \
    $HOME/dotfiles/install.sh buildtools && \
    chsh -s /bin/zsh

CMD ["/bin/bash"]
