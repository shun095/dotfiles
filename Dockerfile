FROM ubuntu

### Only for local repository
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y locales sudo curl lsb-release git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen ja_JP.UTF-8 \
    && export LANG=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8 \
    && useradd -m -s /bin/bash shun095 \
    && echo 'shun095 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && chsh -s /bin/zsh

USER shun095
WORKDIR /home/shun095

COPY --chown=shun095:shun095 . /home/shun095/dotfiles

RUN if [ -f $HOME/dotfiles/install-invoke.sh ]; then \
        # For local repository
        echo "dotfiles installer is found. Using existing installer: $HOME/dotfiles/install-invoke.sh"; \
        $HOME/dotfiles/install-invoke.sh; \
    else \
        # For trial with crean environment
        echo "dotfiles installer is not found. Fetching from the latest repo."; \
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/shun095/dotfiles/master/install.sh)"; \
    fi \
    && $HOME/dotfiles/install-invoke.sh buildtools \
    && $HOME/dotfiles/install-invoke.sh \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
