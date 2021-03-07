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
TMUXPLUGINSDIR="$HOME/.tmux/plugins"
TMUXTPMDIR="$TMUXPLUGINSDIR/tpm"

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
TIGRC="$HOME/.tigrc"
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
    ${TIGRC}
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
    "${MYDOTFILES}/tig/tigrc"
)

# actual files
TMUXLOCAL="$HOME/localrcs/tmux-local"
TRASH="$HOME/.trash"

help() {
    cat << EOF

usage: $0 [arg]

    --help      Show this message
    install     Unstall
    buildtools  Build tools from newest codes
    reinstall   Refetch zsh-plugins from repository and reinstall.
    redeploy    Delete symbolic link and link again.
    update      Update plugins
    undeploy    Delete symbolic link
    uninstall   Uninstall

EOF
}


ascii_art() {
    cat << EOF
[34m
     _     _   ___ _ _
   _| |___| |_|  _|_| |___ ___
  | . | . |  _|  _| | | -_|_ -|
  |___|___|_| |_| |_|_|___|___|

[7m                by shun095[0m
EOF
sleep 1
}

echo_section() {
    local desc=$1
    local num_desc=${#desc}
    local num_remain=$(tput cols)
    local result=''

    for i in $(seq 5); do
        result="${result}="
        num_remain=$((${num_remain}-1))
    done
    result="${result} "
    num_remain=$((${num_remain}-1))

    result="${result}${desc}"
    num_remain=$((${num_remain}-${num_desc}))

    result="${result} "
    num_remain=$((${num_remain}-1))

    for i in $(seq ${num_remain}); do
        result="${result}="
    done
    echo -e "\n[32m${result}\n[0m"
}

update_repositories() {
    echo_section "Upgrading plugin repositories"

    pushd ${MYDOTFILES}
        git pull
    popd
    echo "Upgrading fzf repository"
    pushd ${FZFDIR}
        git pull
    popd
    echo "Upgrading oh-my-zsh repository"
    pushd ${OHMYZSHDIR}
        set +e
        ./tools/upgrade.sh
        set -e
        if [[ ! ($? == 80 || $? == 0) ]];then
            exit $?
        fi
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
    echo "Upgrading tmux tpm repository"
    pushd ${TMUXTPMDIR}
        git pull
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
    echo_section "Removeing existing RC files"

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
    echo_section "Configuring Git"
    set -x
    # git config --global core.editor vim
    git config --global alias.graph "log --graph --all --date=local --pretty=format:'%C(auto)%h%C(magenta) %cd %C(yellow)[%cr]%C(auto)%d%n    %C(auto)%s%n    %C(green)Committer:%cN <%cE>%n    %C(blue)Author   :%aN <%aE>%Creset'"
    # git config --global pager.diff "diff-so-fancy | less --tabs=4 -RFX"
    # git config --global pager.show "diff-so-fancy | less --tabs=4 -RFX"
    set +x
}

download_plugin_repositories(){
    # install fzf
    if [[ ! -e ${FZFDIR} ]]; then
        echo_section "Downloading fzf"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &
    fi

    if [[ ! -e ${OHMYZSHDIR} ]]; then
        echo_section "Downloading oh my zsh"
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

    if [[ ! -e ${TMUXTPMDIR} ]]; then
        git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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
    echo_section "Installing oh my zsh"

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
    echo_section "Installing RC files"
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
    echo_section "Installing fzf"
    ~/.fzf/install --completion --key-bindings --update-rc
}

##############################################
#               MAIN COMMANDS                #
##############################################

backup() {
    echo_section "Making back up files"
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
    echo_section "Compiling zsh files"
    case $SHELL in
        */zsh)
            # assume Zsh
            $MYDOTFILES/tools/zsh_compile.zsh || true
            ;;
        *)
            if type zsh > /dev/null 2>&1; then
                zsh $MYDOTFILES/tools/zsh_compile.zsh || true
            else
                echo -e "\nCurrent shell is not zsh. skipping.\n"
            fi
    esac
}

clone_dotfiles_repository() {
    echo_section "Cloning dotfiles repository"
    if [[ ! -d $MYDOTFILES/.git ]]; then
        if [[ -d $MYDOTFILES ]]; then
            rm -rf $MYDOTFILES
        fi
        git clone https://github.com/ishitaku5522/dotfiles $MYDOTFILES
    else
        echo "Nothing to do."
    fi
}

install_essential_dependencies() {
    local deps=''
    if !(type git > /dev/null 2>&1); then
        deps="${deps} git"
    fi
    if !(type vim > /dev/null 2>&1); then
        deps="${deps} vim"
    fi
    if !(type tmux > /dev/null 2>&1); then
        deps="${deps} tmux"
    fi
    if !(type zsh > /dev/null 2>&1); then
        deps="${deps} zsh"
    fi

    if type apt-get > /dev/null 2>&1; then
        # Ubuntu has mawk as default and this replace it.
        if !(type gawk > /dev/null 2>&1); then
            deps="${deps} gawk"
        fi
    fi

    install_deps "essential softwares" "${deps}"

    clone_dotfiles_repository
}

install_vim_plugins() {
    echo_section "Installing vim plugins"

    export PATH=$PATH:$HOME/build/vim/bin

    if type vim > /dev/null 2>&1 && type git > /dev/null 2>&1; then
        if [[ ! -d $HOME/.vim/plugged ]]; then
            vim --not-a-term --cmd 'set shortmess=a cmdheight=2' -c ':PlugInstall --sync' -c ':qa!'
        fi
    fi
    echo "Installed."
}

update_vim_plugins() {
    echo_section "Updating vim plugins"

    export PATH=$PATH:$HOME/build/vim/bin

    if type vim > /dev/null 2>&1 && type git > /dev/null 2>&1; then
        if [[ -d $HOME/.vim/plugged ]]; then
            vim --not-a-term --cmd 'set shortmess=a cmdheight=5' -c ':PlugUpgrade' -c ':qa!'
            vim --not-a-term --cmd 'set shortmess=a cmdheight=5' -c ':PlugUpdate --sync' -c ':qa!'
            # $MYDOTFILES/tools/update_vimplugin_repos.sh
        fi
    fi
    echo "Updated."
}

install_deps() {
    local msg=$1
    local deps=$2
    echo_section "Installing dependencies for: ${msg}"
    local sudo=""

    if [[ ${deps} = '' ]]; then
        echo "Nothing to do."
        return
    fi

    echo
    echo "Packages:"
    echo "  ${deps}"
    echo

    if [[ ! $(whoami) = 'root' ]]; then
        sudo="sudo "
    fi

    if type brew > /dev/null 2>&1; then
        brew update
        brew upgrade
        brew install ${deps}
    elif type apt-get > /dev/null 2>&1; then
        ${sudo} apt-get update
        ${sudo} apt-get upgrade -y
        ${sudo} apt-get install -y ${deps}
    elif type yum > /dev/null 2>&1; then
        ${sudo} yum update
        if ${sudo} yum list installed git2u >/dev/null 2>&1; then
            :
        else
            ${sudo} yum remove git* -y
        fi
        ${sudo} yum install -y https://centos7.iuscommunity.org/ius-release.rpm || true
        ${sudo} yum install -y ${deps} || true
    fi
}

build_vim_install_deps() {
    local deps=""
    if type apt-get > /dev/null 2>&1; then
        deps='git gettext libtinfo-dev libacl1-dev libgpm-dev build-essential libncurses5-dev libncursesw5-dev python3-dev ruby-dev lua5.2 liblua5.2-dev luajit libluajit-5.1'
    elif type yum > /dev/null 2>&1; then
        deps='git2u gcc make ncurses ncurses-devel tcl-devel ruby ruby-devel lua lua-devel luajit luajit-devel python36u python36u-devel'
    fi
    install_deps "vim build" "${deps}"
}

build_tmux_install_deps() {
    local deps=""
    if type apt-get > /dev/null 2>&1; then
        deps='git automake pkg-config libevent-dev libncurses5-dev libncursesw5-dev bison'
    elif type yum > /dev/null 2>&1; then
        deps='git2u automake libevent-devel ncurses-devel make gcc byacc'
    fi
    install_deps "tmux build" "${deps}"
}

make_install() {
    local script=$1
    local repo=$2

    if [[ ! -d $HOME/programs ]]; then
        mkdir -p $HOME/programs
    fi

    pushd $HOME/programs
        if [[ ! -e ${script} ]]; then
            ln -s $MYDOTFILES/tools/${script}
        fi

        if [[ ! -d $(echo "${repo}" | rev | cut -d'/' -f 1 | rev) ]]; then
            git clone --depth 1 ${repo}
        fi

        chmod +x ./${script}
        ./${script}
    popd
}


build_vim_make_install() {
    echo_section "Compiling vim"
    make_install "vim_myconfigure.sh" "https://github.com/vim/vim"
}

build_tmux_make_install() {
    echo_section "Compiling tmux"
    make_install "tmux_myconfigure.sh" "https://github.com/tmux/tmux"
}

build_tig_make_install() {
    echo_section "Compiling tig"
    make_install "tig_myconfigure.sh" "https://github.com/jonas/tig"
}

build_ranger_make_install() {
    echo_section "Installing ranger"
    make_install "ranger_myconfigure.sh" "https://github.com/ranger/ranger"
}

build_vim(){
    build_vim_install_deps
    build_vim_make_install
}

build_tmux(){
    # automake pkg-config libevent-dev libncurses5-dev libncursesw5-dev
    build_tmux_install_deps
    build_tmux_make_install
}

uninstall_built_tools(){
    \unlink $HOME/programs/vim_myconfigure.sh
    \rm -rf $HOME/programs/vim
    \rm -rf $HOME/build/vim

    \unlink $HOME/programs/tmux_myconfigure.sh
    \rm -rf $HOME/programs/tmux
    \rm -rf $HOME/build/tmux
}

buildtools(){
    build_vim
    build_tmux
    build_tig_make_install
    build_ranger_make_install
}

deploy() {
    deploy_ohmyzsh_files
    deploy_selfmade_rcfiles
    deploy_fzf
    compile_zshfiles
    install_vim_plugins

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
    # build_vim_make_install
    # build_tmux_make_install
    # build_tig_make_install
    # build_ranger_make_install
    redeploy
    update_vim_plugins
}

install() {
    install_essential_dependencies
    download_plugin_repositories
    undeploy
    deploy
}

uninstall() {
    uninstall_plugins
    uninstall_built_tools
    undeploy
}

reinstall() {
    uninstall
    install
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
        buildtools)     ;;
        *)
            echo "Unknown argument: ${arg}"
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

check_arguments ${arg}
ascii_art
echo "Argument: ${arg}"

if [[ ${arg} != "debug" ]]; then
    backup
    ${arg}
fi

echo -e "\nDone.\n"
