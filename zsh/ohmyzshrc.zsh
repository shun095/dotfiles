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
    adb::lazy
    aws::lazy
    cloudfoundry:cf:lazy
    dnf::lazy
    docker::lazy
    docker-compose::lazy
    emacs::lazy
    flutter::lazy
    fzf::lazy
    gcloud::lazy
    git:git:lazy
    golang:go:lazy
    gradle::lazy
    helm::lazy
    kube-ps1:kubectl:lazy
    kubectl::lazy
    minikube::lazy
    mvn::lazy
    node::lazy
    npm::lazy
    pip:pip:lazy
    pip:pip3:lazy
    postgres:psql:lazy
    pyenv:pyenv:lazy
    python:python:lazy
    python:python3:lazy
    ripgrep:rg:lazy
    rust:cargo:lazy
    ssh-agent::lazy
    sudo::lazy
    systemd:systemctl:lazy
    tig::lazy
    vagrant::lazy
    vscode:code:lazy
    yarn::lazy
    yum::lazy
)

# Plugins must be loaded always.
plugins=(
    zsh-defer
)

lazy_plugins=(
    git-auto-fetch
    gnu-utils
    history-substring-search
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
)

_IFS=$IFS
IFS=:
while read plugin cmd lazy
do
    if [[ $cmd = "" || $cmd = $plugin ]]; then;
        cmd=true
    fi

    if [[ "$lazy" = "lazy" ]]; then
        lazy_plugins+=("$plugin:$cmd")
    else
        if type $cmd >/dev/null 2>&1; then
            plugins+=($plugin)
        fi
    fi
done < <(for line in $plugins_with_command; do echo $line;done)
IFS=$_IFS

function compinit(){
    . $ZSH/custom/plugins/zsh-defer/zsh-defer.plugin.zsh
    autoload -Uz compinit && zsh-defer -12dmszpr -t0.1 compinit $@
}

function compdef(){
    autoload -Uz compinit && zsh-defer -12dmszpr -t0.1 compdef $@
}

. $ZSH/oh-my-zsh.sh

if [ -f ~/.fzf.zsh ]; then
    zsh-defer -12dmszpr -t0.1 source $HOME/.fzf.zsh
fi

_IFS=$IFS
IFS=:
while read plugin cmd
do
    if [[ $cmd = "" || $cmd = $plugin ]]; then;
        cmd=true
    fi

    zsh-defer -12dmszpr -t0.1 -c "if type $cmd >/dev/null 2>&1; then _omz_source \"plugins/$plugin/$plugin.plugin.zsh\"; fi"
done < <(for line in $lazy_plugins; do echo $line; done)
IFS=$_IFS

