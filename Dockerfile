FROM ubuntu

### Only for local repository
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update 
RUN apt-get install -y locales \
    && locale-gen ja_JP.UTF-8 \
    && export LANG=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8

RUN apt-get install -y sudo \
    && useradd -m -s /bin/bash shun095 \
    && echo 'shun095 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get install -y curl lsb-release git

USER shun095
WORKDIR /home/shun095

COPY --chown=shun095:shun095 . /home/shun095/dotfiles
RUN $HOME/dotfiles/install-invoke.sh
RUN $HOME/dotfiles/install-invoke.sh buildtools
RUN $HOME/dotfiles/install-invoke.sh
RUN $HOME/dotfiles/install-invoke.sh runtest

# RUN apt-get install -y curl lsb-release git \
    # && if [ -f $HOME/dotfiles/install-invoke.sh ]; then \
        # echo "dotfiles installer is found. Using existing installer: $HOME/dotfiles/install.sh"; \
        # $HOME/dotfiles/install-invoke.sh; \
    # else \
        # echo "dotfiles installer is not found. Fetching from the repo."; \
        # bash -c "$(curl -fsSL https://raw.githubusercontent.com/shun095/dotfiles/master/install.sh)"; \
    # fi \
    # && chsh -s /bin/zsh \
    # && apt-get clean \
    # && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
