FROM ubuntu

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl lsb-release && \
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ishitaku5522/dotfiles/master/install.sh)" && \
    ~/dotfiles/install.sh buildtools && \
    chsh -s /bin/zsh

CMD ["/bin/bash"]
