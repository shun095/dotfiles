#!/usr/bin/env zsh
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="ishitaku"
COMPLETION_WAITING_DOTS="true"

# Plugins must be loaded if necessary.
# <plugin name>:<check command>
plugins_with_command=(
    pyenv-lazy:pyenv
)

# Plugins must be loaded always.
plugins=(
    zsh-defer
)

lazy_plugins=(
    alias-finder
    aliases
    colorize
    command-not-found
    common-aliases
    cp
    fancy-ctrl-z
    git-auto-fetch
    git-escape-magic
    gnu-utils
    history
    macos
    safe-paste
    timer
    zsh-interactive-cd
    zsh-autosuggestions
    zsh-completions
    history-substring-search
    zsh-syntax-highlighting
    # zsh-navigation-tools
)

lazy_plugins_with_command=(
    ansible
    aws
    brew
    cloudfoundry:cf
    deno
    dnf
    docker
    docker-compose
    emacs
    flutter
    fzf
    gcloud
    gh
    git
    golang:go
    gradle
    helm
    istioctl
    k9s
    kn
    kube-ps1:kubectl
    kubectl
    kubectx
    microk8s
    minikube
    mvn
    node
    nodenv
    npm
    nvm
    oc
    perl
    pip:pip
    pip:pip3
    podman
    postgres:psql
    pyenv
    python
    python:python3
    rsync
    ruby
    rust:cargo
    scala
    screen
    snap
    ssh
    ssh-agent
    sudo
    systemd:systemctl
    tailscale
    terraform
    tig
    tmux
    ubuntu
    vagrant
    virtualenv
    vscode:code
    xcode:xcode-select
    yarn
    yum
)

while IFS=: read plugin cmd
do
    # echo plugins_with_command p:$plugin c:$cmd
    if [[ $cmd = "" || $cmd = $plugin ]]; then;
        cmd=$plugin
    fi

    if type $cmd >/dev/null 2>&1; then
        plugins+=($plugin)
    fi
done < <(for line in $plugins_with_command; do echo $line;done)

# zsh-defer option memo.
# Opt. | Action                                                |
# ---- |-------------------------------------------------------|
# 1    | Redirect standard output to `/dev/null`.              |
# 2    | Redirect standard error to `/dev/null`.               |
# d    | Call `chpwd` hooks.                                   |
# m    | Call `precmd` hooks.                                  |
# s    | Invalidate suggestions from zsh-autosuggestions.      |
# z    | Invalidate highlighting from zsh-syntax-highlighting. |
# p    | Call `zle reset-prompt`.                              |
# r    | Call `zle -R`.                                        |
# a    | Shorthand for all options: *12dmszpr*.                |

compinit(){ 
    args=$@
    . $ZSH/custom/plugins/zsh-defer/zsh-defer.plugin.zsh
    zsh-defer +12 -dmszr +p -t0.001 -c "RPROMPT=\"Executing compinit...\";"
    zsh-defer +12 -d +m -sz +rp -t0.001 -c "unfunction compinit; unfunction compdef; autoload -Uz compinit && compinit $args"
}

compdef(){
    args=$@
    zsh-defer +12 -dmszr +p -t0.001 -c "RPROMPT=\"Executing compdef...\";"
    zsh-defer +12 -d +m -sz +rp -t0.001 -c "compdef $args"
}

# source(){

#     echo "start `date +%s.%3N`"
#     echo "Source: " $@
#     . $@
#     echo "end   `date +%s.%3N`"

# }

source $ZSH/oh-my-zsh.sh

if [ -f ~/.fzf.zsh ]; then
    plugin=fzf
    zsh-defer +12 -dmszr +p -t0.001 -c "RPROMPT=\"Loading $plugin...\";"
    zsh-defer +12 -d +m -sz +rp -t0.001 -c "source $HOME/.fzf.zsh"
fi

while IFS= read plugin
do
    cmd=true
    # lazy_plugins_with_command+=("$plugin:$cmd")
    lazy_plugins_with_command=("$plugin:$cmd" "${lazy_plugins_with_command[@]}")
done < <(for line in $lazy_plugins; do echo $line; done)

while IFS=: read plugin cmd
do
    if [[ "$cmd" = "" ]]; then
        cmd=$plugin
    fi

    if is_plugin "$ZSH_CUSTOM" "$plugin"; then
        fpath=("$ZSH_CUSTOM/plugins/$plugin" $fpath)
    elif is_plugin "$ZSH" "$plugin"; then
        fpath=("$ZSH/plugins/$plugin" $fpath)
    else
        echo "[oh-my-zsh] plugin '$plugin' not found"
    fi

    zsh-defer +12 -dmszr +p -t0.001 -c "RPROMPT=\"Loading $plugin...\";"
    zsh-defer +12 -d +m -sz +rp -t0.001 -c "
        if type $cmd >/dev/null 2>&1; then
            _omz_source \"plugins/$plugin/$plugin.plugin.zsh\"; 
        fi"
done < <(for line in $lazy_plugins_with_command; do echo $line; done)

zsh-defer +12dmszrp -t0.001 -c "RPROMPT="
