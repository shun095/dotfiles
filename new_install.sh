#!/usr/bin/env zsh

set -eu

export MYDOTFILES=$HOME/dotfiles

# directories
FZFDIR="$HOME/.fzf"
ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"

# symlinks
ZSHRC="$HOME/.zshrc"
VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"
TMUXCONF="$HOME/.tmux.conf"
FLAKE8="$HOME/.config/flake8"
VINTRC="$HOME/.vintrc.yml"
EMACSINIT="$HOME/.emacs.d/init.el"

SYMLINKS=(
${VIMRC}
${GVIMRC}
${TMUXCONF}
${FLAKE8}
${VINTRC}
${EMACSINIT}
)

SYMTARGET=(
"${MYDOTFILES}/vim/vimrc.vim"
"${MYDOTFILES}/vim/gvimrc.vim"
"${MYDOTFILES}/tmux/tmux.conf"
"${MYDOTFILES}/python/lint/flake8"
"${MYDOTFILES}/python/lint/vintrc.yml"
"${MYDOTFILES}/emacs/init.el"
)

# actual files
TMUXLOCAL="$HOME/localrcs/tmux-local"
TRASH="$HOME/.trash"

help() {
    cat << EOF
    usage: $0 [arg]
    --help    Show this message
    reinstall Refetch zsh-plugins from repository and reinstall.
    redeploy  Delete symbolic link and link again.
    update    Update plugins
    undeploy  Delete symbolic link
    uninstall Uninstall
EOF
}


ascii_art() {
    cat << EOF
        ____  ____  __________________    ___________
       / __ \/ __ \/_  __/ ____/  _/ /   / ____/ ___/
      / / / / / / / / / / /_   / // /   / __/  \__ \ 
     / /_/ / /_/ / / / / __/ _/ // /___/ /___ ___/ / 
    /_____/\____/ /_/ /_/   /___/_____/_____//____/  

    Author: ishitaku5522

EOF
}

update_repositories() {
        echo "Checking zprezto repository"
        pushd ${ZPREZTODIR}
        git pull && git submodule update --init --recursive
        popd

        echo "Checking fzf repository"
        pushd ${FZFDIR}
        git pull
        popd
}

backup_file() {
    if [[ -e "$1" ]]; then
        for idx in `seq 3 -1 0`; do
            if [[ -e "$1.bak$idx" ]]; then
                echo "Renaming exist backup $1.bak$idx to $1.bak$(($idx+1))"
                mv "$1.bak$idx" "$1.bak$(($idx+1))"
            fi
        done

        echo "Making backup of $1 to $1.bak0"
        cp $1 $1.bak0
    fi
}

remove_rcfiles_symlink() {
    if [[ -L $1 ]]; then
        echo "Removing symlink: $1"
        \unlink $1
    elif [[ -f $1 ]]; then
        echo "$1 is not symlink."
        \rm -i $1
    else
        echo "$1 does not exists. Doing nothing."
    fi
}

remove_rcfiles() {
        echo "\n==========Remove existing RC files==========\n"

        setopt EXTENDED_GLOB
        for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
            remove_rcfiles_symlink "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        done

        for item in ${SYMLINKS[@]}; do
            remove_rcfiles_symlink $item
        done
        unset item
}

uninstall_plugins() {
    echo "Remove fzf and zprezto directory"
    \rm -rf $ZPREZTODIR
    $HOME/.fzf/uninstall
}

git_configulation() {
    git config --global core.editor vim
    git config --global alias.graph "log --graph --all --pretty=format:'%C(auto)%h%d%n  %s %C(magenta)(%cr)%n    %C(green)Committer:%cN <%cE>%n    %C(blue)Author   :%aN <%aE>%Creset' --abbrev-commit --date=relative"
}


download_repositories(){
    # install fzf
    if [[ ! -e ${FZFDIR} ]]; then
        echo "\n==========Download fzf==========\n"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi

    # download zprezto
    if [[ ! -e ${ZPREZTODIR} ]]; then
        echo "\n==========Download zprezto==========\n"
        git clone --recursive https://github.com/zsh-users/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
        #   git -C ${ZDOTDIR:-$HOME}/.zprezto submodule foreach git pull origin master
    fi
}

append_line() {
    set -e

    local update line file pat lno
    update="$1"
    line="$2"
    file="$3"
    pat="${4:-}"

    echo "Update $file:"
    echo "  - $line"
    [ -f "$file" ] || touch "$file"
    if [ $# -lt 4 ]; then
        lno=$(\grep -nF "$line" "$file" | sed 's/:.*//' | tr '\n' ' ')
    else
        lno=$(\grep -nF "$pat" "$file" | sed 's/:.*//' | tr '\n' ' ')
    fi
    if [ -n "$lno" ]; then
        echo "    - Already exists: line #$lno"
    else
        if [ $update -eq 1 ]; then
            echo >> "$file"
            echo "$line" >> "$file"
            echo "    + Added"
        else
            echo "    ~ Skipped"
        fi
    fi
    echo
    set +e
}

deploy_prezto_files() {
    echo "\n==========Install prezto==========\n"
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
        if [[ ! -e "${ZDOTDIR:-$HOME}/.${rcfile:t}" ]]; then
            echo "Link .${rcfile:t}"
            ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
        else
            echo "${rcfile:t} already exists!!"
        fi
    done

    # use customized zpreztorc
    rm ${ZDOTDIR:-$HOME}/.zpreztorc
    ln -s ${MYDOTFILES}/zsh/zpreztorc ${ZDOTDIR:-$HOME}/.zpreztorc

    # restore zshrc backup if exists
    if [[ -e "$HOME/.zshrc.bak0" ]]; then
        echo "Restore backup of zshrc"
        cat ~/.zshrc.bak0 > ~/.zshrc
    fi

    # append line if zshrc doesn't has below line
    append_line 1 "source $MYDOTFILES/zsh/zshrc" "$HOME/.zshrc"
}

deploy_selfmade_rcfiles() {
    # make symlinks
    echo "\n==========Install RC files==========\n"
    for i in `seq 1 ${#SYMLINKS[@]}`; do
        if [[ ! -e ${SYMLINKS[${i}]} ]]; then
            touch ${SYMTARGET[${i}]}
            ln -s ${SYMTARGET[${i}]} ${SYMLINKS[${i}]}
            echo "Link" ${SYMLINKS[${i}]:t}
        else
            echo "${SYMLINKS[${i}} already exists!!"
        fi
    done
}

deploy_fzf() {
    echo "\n==========Install fzf==========\n"
    ~/.fzf/install --completion --key-bindings --update-rc
}


#MAIN COMMANDS
backup() {
    backup_file $ZSHRC
}

deploy() {
    deploy_prezto_files
    deploy_selfmade_rcfiles
    deploy_fzf
}

install() {
    ascii_art
    download_repositories
    update_repositories
    remove_rcfiles
    deploy
}

reinstall() {
    uninstall_plugins
    install
}

redeploy() {
    remove_rcfiles
    deploy
}

update() {
    ascii_art
    update_repositories
    redeploy
}

uninstall() {
    uninstall_plugins
    remove_rcfiles
}

# MAIN
if [[ $# -eq 0 ]]; then
    arg="install"
    echo "install"
else
    arg=$1
fi

if [[ $arg != "debug" ]]; then
    backup
fi

case $arg in
    --help)
        help
        exit 0
        ;;
    install)
        install
        ;;
    reinstall)
        reinstall
        ;;
    redeploy) 
        redeploy
        ;;
    update)
        update
        ;;
    undeploy)
        remove_rcfiles
        ;;
    uninstall) 
        uninstall
        ;;
    debug)
        backup_file $2
        ;;
    *)
        echo "Unknown argument: $arg"
        help
        exit 1
        ;;
esac

git_configulation

# Not symlink
if [[ ! -e ${TMUXLOCAL} ]]; then
    mkdir -p $HOME/localrcs
    touch $HOME/localrcs/tmux-local
    echo "tmuxlocal is made"
fi

if [[ ! -e ${TRASH} ]]; then
    mkdir ${TRASH}
fi
