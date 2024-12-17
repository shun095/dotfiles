# vim:ft=zsh
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="ishitaku"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# 
# Plugins must be loaded if necessary.
# <plugin name>:<check command>
plugins_with_command=(
)

# Plugins must be loaded always.
plugins=(
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
    history-substring-search
    macos
    safe-paste
    timer
    zsh-autosuggestions
    zsh-completions
    zsh-interactive-cd
    zsh-navigation-tools
    zsh-syntax-highlighting
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

function compinit(){ unfunction compinit
    . $ZSH/custom/plugins/zsh-defer/zsh-defer.plugin.zsh
    zsh-defer -12dmszr +p -t0.001 -c "RPROMPT=\"Executing compinit...\";"
    autoload -Uz compinit && zsh-defer -12dmszpr -t0.001 compinit $@
}

function compdef(){
    zsh-defer -12dmszr +p -t0.001 -c "RPROMPT=\"Executing compdef...\";"
    autoload -Uz compinit && zsh-defer -12dmszpr -t0.001 compdef $@
}

# function source(){

#     echo "start `date +%s.%3N`"
#     echo "Source: " $@
#     . $@
#     echo "end   `date +%s.%3N`"

# }

source $ZSH/oh-my-zsh.sh

if [ -f ~/.fzf.zsh ]; then
    zsh-defer -12dmszr +p -t0.001 -c "
        RPROMPT=\"Loading $plugin...\"; 
        source $HOME/.fzf.zsh"
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

    zsh-defer -12dmszr +p -t0.001 -c "
        if type $cmd >/dev/null 2>&1; then
            RPROMPT=\"Loading $plugin...\";
            _omz_source \"plugins/$plugin/$plugin.plugin.zsh\"; 
        fi"
done < <(for line in $lazy_plugins_with_command; do echo $line; done)

zsh-defer -12 +dmszpr -t0.001 -c "RPROMPT=Completed!"
zsh-defer -12dmszr +p -t1 -c "RPROMPT="
