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
    adb
    aws
    cloudfoundry:cf
    dnf
    docker
    docker-compose
    emacs
    flutter
    fzf
    gcloud
    git
    golang:go
    gradle
    helm
    kube-ps1:kubectl
    kubectl
    minikube
    mvn
    node
    npm
    pip:pip
    pip:pip3
    postgres:psql
    pyenv:pyenv
    python:python
    python:python3
    ripgrep:rg
    rust:cargo
    ssh-agent
    sudo
    systemd:systemctl
    tig
    vagrant
    vscode:code
    yarn
    yum
)

# Plugins must be loaded always.
plugins=(
    git-auto-fetch
    git-escape-magic
    gnu-utils
    history-substring-search
    zsh-completions
    zsh-syntax-highlighting
    zsh-autosuggestions
)

for plugin_cmd in $plugins_with_command
do
    plugin=$(echo $plugin_cmd | cut -d: -f 1)
    cmd=$(echo $plugin_cmd | cut -d: -f 2)

    if type $cmd >/dev/null 2>&1; then
        plugins+=($plugin)
    fi
done

. $ZSH/oh-my-zsh.sh
