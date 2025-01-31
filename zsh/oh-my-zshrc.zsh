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
    zsh-completions
    zsh-autosuggestions
    zsh-interactive-cd
    zsh-syntax-highlighting
    history-substring-search
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

compinit(){ 
    args=$@
    . $ZSH/custom/plugins/zsh-defer/zsh-defer.plugin.zsh
    zsh-defer +12 -dmszr +p -t0.001 -c "RPROMPT=\"Executing compinit...\";"
    zsh-defer +12 -dmszpr -t0.001 -c "unfunction compinit; unfunction compdef; autoload -Uz compinit && compinit $args"
}

compdef(){
    args=$@
    zsh-defer +12 -dmszr +p -t0.001 -c "RPROMPT=\"Executing compdef...\";"
    zsh-defer +12 -dmszpr -t0.001 -c "compdef $args"
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
    zsh-defer +12 -dmszrp -t0.001 -c "source $HOME/.fzf.zsh"
fi

while IFS= read plugin
do
    cmd=true
    # echo lazy_plugins p:$plugin c:$cmd
    lazy_plugins_with_command+=("$plugin:$cmd")
done < <(for line in $lazy_plugins; do echo $line; done)

while IFS=: read plugin cmd
do
    if [[ "$cmd" = "" ]]; then
        cmd=$plugin
    fi
    # echo lazy_plugins_with_command p:$plugin c:$cmd

    if is_plugin "$ZSH_CUSTOM" "$plugin"; then
        fpath=("$ZSH_CUSTOM/plugins/$plugin" $fpath)
    elif is_plugin "$ZSH" "$plugin"; then
        fpath=("$ZSH/plugins/$plugin" $fpath)
    else
        echo "[oh-my-zsh] plugin '$plugin' not found"
    fi

    zsh-defer +12 -dmszr +p -t0.001 -c "RPROMPT=\"Loading $plugin...\";"
    zsh-defer +12 -dmszrp -t0.001 -c "
        if type $cmd >/dev/null 2>&1; then
            _omz_source \"plugins/$plugin/$plugin.plugin.zsh\"; 
        fi"
done < <(for line in $lazy_plugins_with_command; do echo $line; done)

zsh-defer +12dmszpr -t0.001 -c "RPROMPT="
