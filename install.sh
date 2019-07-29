#!/usr/bin/env bash
#
# install.sh
# Copyright (C) 2018 ishitaku5522
#
# Distributed under terms of the MIT license.

set -eu

export MYDOTFILES=$HOME/dotfiles

if [ ! -z ${ZSH_NAME:-} ];then
  setopt localoptions ksharrays
  echo "runnning on zsh"
fi

#tseoitj aowiejfoajiwe

# directories
FZFDIR="$HOME/.fzf"
ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"
OHMYZSHDIR="$HOME/.oh-my-zsh"

# symlinks
ZSHRC="$HOME/.zshrc"

ZSHFILES=(
"$HOME/.zshrc"
"$HOME/.zlogin" 
"$HOME/.zlogout"
"$HOME/.zpreztorc"
"$HOME/.zprofile"
"$HOME/.zshenv"
)

VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"
TMUXCONF="$HOME/.tmux.conf"
FLAKE8="$HOME/.config/flake8"
VINTRC="$HOME/.vintrc.yml"
EMACSINIT="$HOME/.spacemacs"
if [[ $OSTYPE == 'msys' ]]; then
    NVIMRC="$USERPROFILE/AppData/Local/nvim/init.vim"
    GNVIMRC="$USERPROFILE/AppData/Local/nvim/ginit.vim"
else
    NVIMRC="$HOME/.config/nvim/init.vim"
    GNVIMRC="$HOME/.config/nvim/ginit.vim"
fi

SYMLINKS=(
${VIMRC}
${GVIMRC}
${TMUXCONF}
${FLAKE8}
${VINTRC}
${EMACSINIT}
${NVIMRC}
${GNVIMRC}
)

SYMTARGET=(
"${MYDOTFILES}/vim/vimrc.vim"
"${MYDOTFILES}/vim/gvimrc.vim"
"${MYDOTFILES}/tmux/tmux.conf"
"${MYDOTFILES}/python/lint/flake8"
"${MYDOTFILES}/python/lint/vintrc.yml"
"${MYDOTFILES}/emacs/spacemacs"
"${MYDOTFILES}/vim/vimrc.vim"
"${MYDOTFILES}/vim/ginit.vim"
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
sleep 1
}

update_repositories() {
        echo -e "\n===== Checking plugin repositories ===================================\n"

        pushd ${MYDOTFILES}
            git pull
        popd
        echo "Checking fzf repository"
        pushd ${FZFDIR}
            git pull
        popd
        echo "Upgrading oh-my-zsh repository"
        pushd ${OHMYZSHDIR}
            sh ./tools/upgrade.sh
        popd
        echo "Upgrading oh-my-zsh plugins"
        pushd ${OHMYZSHDIR}/custom/plugins
            pushd zsh-syntax-highlighting
                git pull
            popd
            pushd zsh-autosuggestions
                git pull
            popd
            pushd zsh-completions
            git pull
            popd
        popd
    }

backup_file() {
    # .~rc exists
    if [[ -e "$1" ]]; then 
        # .~rc.bak0 exists
        if [[ -e "$1.bak0" ]]; then 
            # .~rc differs from .~rc.bak0
            if [[ $(diff "$1" "$1.bak0") ]]; then 
                for idx in $(seq 3 -1 0); do
                    if [[ -e "$1.bak$idx" ]]; then
                        echo "Renaming exist backup"
                        echo "  from: $1.bak$idx"
                        echo "  to:   $1.bak$(($idx+1))"
                        mv "$1.bak$idx" "$1.bak$(($idx+1))"
                    fi
                done
            fi
        fi

        echo "Making backup"
        echo "  from: $1"
        echo "  to:   $1.bak0"
        cp $1 $1.bak0
    fi
}

remove_rcfiles_symlink() {
    if [[ -L $1 ]]; then
        echo "Removing symlink: $1"
        \unlink $1
    elif [[ -f $1 ]]; then
        echo "Removing normal file: $1"
        \rm -f $1
    else
        echo "$1 does not exists. Doing nothing."
    fi
}

remove_rcfiles() {
    echo -e "\n===== Removeing existing RC files ====================================\n"

    for rcfile in ${ZSHFILES[@]}; do
        name=$(basename $rcfile)
        remove_rcfiles_symlink "${ZDOTDIR:-$HOME}/${name}"
    done

    for item in ${SYMLINKS[@]}; do
        remove_rcfiles_symlink $item
    done
    unset item
}

uninstall_plugins() {
    echo "Removing fzf and zprezto directory"
    if [[ -e $HOME/.fzf/uninstall ]]; then
        $HOME/.fzf/uninstall
    fi
    \rm -rf $ZPREZTODIR
    \rm -rf $FZFDIR
    \rm -rf $OHMYZSHDIR
}

git_configulation() {
    echo -e "\n===== Configuring Git ====================================\n"
    git config --global core.editor vim
    git config --global alias.graph "log --graph --all --date=local --pretty=format:'%C(auto)%h%C(magenta) %cd %C(yellow)[%cr]%C(auto)%d%n    %C(auto)%s%n    %C(green)Committer:%cN <%cE>%n    %C(blue)Author   :%aN <%aE>%Creset'"
}

download_repositories(){
    # install fzf
    if [[ ! -e ${FZFDIR} ]]; then
        echo -e "\n===== Download fzf ===================================================\n"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &
    fi

    if [[ ! -e ${OHMYZSHDIR} ]]; then
        echo -e "\n===== Download oh my zsh =============================================\n"
        git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
        pushd ~/.oh-my-zsh/custom/plugins
            git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git &
            git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions &
            git clone --depth 1 https://github.com/zsh-users/zsh-completions &
        popd

        wait

        if [[ ! -e ${OHMYZSHDIR}/custom/themes ]]; then
            mkdir -p ${OHMYZSHDIR}/custom/themes
        fi
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
}

insert_line() {
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
            if [ -s "$file" ]; then
                sed --in-place --follow-symlinks "1s/^/$line\n/" $file
            else
                echo $line > $file
            fi
            echo "    + Added"
        else
            echo "    ~ Skipped"
        fi
    fi
}

deploy_ohmyzsh_files() {
    echo -e "\n===== Installing oh my zsh ===========================================\n"

    for item in ${ZSHFILES[@]}; do
        # restore zshfiles backup if exists
        if [[ -e "${item}.bak0" ]]; then
            if [[ -e "${item}" ]]; then
                read -r -p "${item} already exists. Overwrite with ${item}.bak0? [y/N] " response
                case "$response" in
                    [yY][eE][sS]|[yY]) 
                        echo "Restore backup of ${item}"
                        cat ${item}.bak0 > ${item}
                        ;;
                    *)  ;;
                esac
            else
                echo "Restore backup of ${item}"
                cat ${item}.bak0 > ${item}
            fi
        fi
    done

    if [[ ! -e ${OHMYZSHDIR}/custom/themes/ishitaku.zsh-theme ]]; then
        ln -s $MYDOTFILES/zsh/ishitaku.zsh-theme ${OHMYZSHDIR}/custom/themes/
    fi

    # append line if zshrc doesn't has below line
    append_line 1 "source $MYDOTFILES/zsh/zshrc.zsh" "$HOME/.zshrc"
    insert_line 1 "skip_global_compinit=1" "$HOME/.zshenv"
}

deploy_selfmade_rcfiles() {
    # make symlinks
    echo -e "\n===== Installing RC files ============================================\n"
    final_idx_simlinks=$(expr ${#SYMLINKS[@]} - 1)
    for i in $(seq 0 ${final_idx_simlinks}); do
        if [[ ! -e ${SYMLINKS[${i}]} ]]; then
            mkdir -p $(dirname ${SYMTARGET[${i}]})
            touch ${SYMTARGET[${i}]}
            mkdir -p $(dirname ${SYMLINKS[${i}]})
            ln -s ${SYMTARGET[${i}]} ${SYMLINKS[${i}]}
            echo "Made link: ${SYMLINKS[${i}]}"
            echo "           --> ${SYMTARGET[${i}]}"
        else
            echo "${SYMLINKS[${i}]} already exists!!"
        fi
    done
}

deploy_fzf() {
    echo -e "\n===== Installing fzf =================================================\n"
    ~/.fzf/install --completion --key-bindings --update-rc
}

##############################################
#               MAIN COMMANDS                #
##############################################

backup() {
    echo -e "\n===== Making back up files ===========================================\n"
    for item in ${ZSHFILES[@]}; do
        if [[ -e $item ]]; then
            backup_file $item
        fi
    done

    for item in ${SYMLINKS[@]}; do
        if [[ -e $item ]]; then
            backup_file $item
        fi
    done
}

compile_zshfiles() {
    echo -e "\n===== Compiling zsh files ============================================\n"
    case $SHELL in
        */zsh) 
            # assume Zsh
            $MYDOTFILES/tools/zsh_compile.zsh || true
            ;;
        *)
            if type zsh > /dev/null; then
                zsh $MYDOTFILES/tools/zsh_compile.zsh || true
            else
                echo -e "\nCurrent shell is not zsh. skipping.\n"
            fi
    esac
}

install_dependencies() {
    echo -e "\n===== Installing essential sofwares ============================================\n"
    local deps='git zsh tmux'

    if type apt > /dev/null; then
        if [[ $(whoami) = 'root' ]]; then
            apt update
            apt install -y $deps
        else
            sudo apt update
            sudo apt install -y $deps
        fi
    elif type yum > /dev/null; then
        if [[ $(whoami) = 'root' ]]; then
            yum -y install $deps
        else
            sudo yum -y install $deps
        fi
    fi

    if [[ ! -e $MYDOTFILES ]]; then
        git clone https://github.com/ishitaku5522/dotfiles $MYDOTFILES
    fi

    build_vim
}

install_vim_plugins() {
    echo -e "\n===== Installing vim plugins ============================================\n"

    export PATH=$PATH:$HOME/build/vim/bin

    if type vim > /dev/null && type git > /dev/null; then
        if [[ ! -d $HOME/.vim/plugged ]]; then
            vim --not-a-term --cmd 'set shortmess=a cmdheight=2' -c ':silent! :PlugInstall' -c ':silent! :qa!'
        fi
    fi

    echo -e "\n===== Installing vim plugins Finished!! ============================================\n"
}

build_vim_install_deps() {
    echo -e "\n===== Installing vim build dependencies ============================================\n"

    if type apt > /dev/null; then

        local deps='git gettext libtinfo-dev libacl1-dev libgpm-dev build-essential cmake python3-dev ruby-dev lua5.2 liblua5.2-dev luajit libluajit-5.1'

        if [[ $(whoami) = 'root' ]]; then
            apt update
            apt install -y ${deps}
        else
            sudo apt update
            sudo apt install -y ${deps}
        fi

    elif type yum > /dev/null; then

        local deps='gcc make ncurses ncurses-devel cmake git2u-all tcl-devel ruby ruby-devel lua lua-devel luajit luajit-devel python36u python36u-devel'

        if [[ $(whoami) = 'root' ]]; then
            yum remove git* -y
            yum install -y https://centos7.iuscommunity.org/ius-release.rpm || true
            yum install -y ${deps} || true
        else
            sudo yum remove git* -y
            sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm || true
            sudo yum install -y ${deps} || true
        fi
    fi
}

build_vim_make_install() {
    echo -e "\n===== Compiling vim ============================================\n"

    if [[ ! -d $HOME/programs ]]; then
        mkdir -p $HOME/programs
    fi

    pushd $HOME/programs
        if [[ ! -e vim_myconfigure.sh ]]; then
            ln -s $MYDOTFILES/tools/vim_myconfigure.sh
        fi

        if [[ ! -d vim ]]; then
            git clone --depth 1 https://github.com/vim/vim
        fi

        chmod +x ./vim_myconfigure.sh
        ./vim_myconfigure.sh
    popd
}

build_vim(){
    build_vim_install_deps
    build_vim_make_install
}

build_tools(){
    build_vim
}

deploy() {
    deploy_ohmyzsh_files
    deploy_selfmade_rcfiles
    deploy_fzf
    compile_zshfiles
    install_vim_plugins
}

undeploy() {
    remove_rcfiles
}

redeploy() {
    undeploy
    deploy
}

update() {
    update_repositories
    redeploy
}

install() {
    install_dependencies
    download_repositories
    undeploy
    deploy
}

uninstall() {
    uninstall_plugins
    undeploy
}

reinstall() {
    uninstall
    install
}

build(){
    build_tools
}

check_arguments() {
    case $1 in
        --help)
            help
            exit 0
            ;;
        install)   ;;
        reinstall) ;;
        redeploy)  ;;
        update)    ;;
        undeploy)  ;;
        uninstall) ;;
        debug)     ;;
        build)     ;;
        *)
            echo "Unknown argument: $arg"
            help
            exit 1
            ;;
    esac
}

##############################################
#                    MAIN                    #
##############################################

if [[ $# -eq 0 ]]; then
    arg="install"
else
    arg=$1
fi

check_arguments $arg
ascii_art

if [[ $arg != "debug" ]]; then
    backup
    $arg
fi

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

echo -e "\nFINISHED!!!\n"
