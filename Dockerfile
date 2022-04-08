FROM ubuntu

### Only for local repository
COPY . /root/dotfiles
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen ja_JP.UTF-8 \
    && export LANG=ja_JP.UTF-8 LC_ALL=ja_JP.UTF-8 \
    && apt-get install -y curl lsb-release git \
    && if [ -f $HOME/dotfiles/install.sh ]; then \
        echo "dotfiles installer is found. Using existing installer: $HOME/dotfiles/install.sh"; \
        $HOME/dotfiles/install.sh; \
    else \
        echo "dotfiles installer is not found. Fetching from the repo."; \
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/shun095/dotfiles/master/install.sh)"; \
    fi \
    && chsh -s /bin/zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/zsh"]
