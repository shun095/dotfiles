#!/usr/bin/env zsh

set -eu

export MYDOTFILES=$HOME/dotfiles

if [ ! -z ${ZSH_NAME:-} ];then
  setopt localoptions ksharrays
  echo "runnning on zsh"
fi

# directories
FZFDIR="$HOME/.fzf"
ZPREZTODIR="${ZDOTDIR:-$HOME}/.zprezto"
OHMYZSHDIR="$HOME/.oh-my-zsh"

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
sleep 1
}

update_repositories() {
        echo -e "\n===== Checking plugin repositories ===================================\n"

        echo "Checking fzf repository"
        pushd ${FZFDIR}
        git pull
        popd
        sh ${OHMYZSHDIR}/tools/upgrade.sh
}

backup_file() {
    # .~rc exists
    if [[ -e "$1" ]]; then 
        # .~rc.bak0 exists
        if [[ -e "$1.bak0" ]]; then 
            # .~rc differs from .~rc.bak0
            if [[ $(diff "$1" "$1.bak0") ]]; then 
                for idx in `seq 3 -1 0`; do
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
        echo "$1 is not symlink."
        \rm -f $1
    else
        echo "$1 does not exists. Doing nothing."
    fi
}

remove_rcfiles() {
        echo -e "\n===== Remove existing RC files =======================================\n"

        ZSHFILES=("zlogin" "zlogout" "zpreztorc" "zprofile" "zshenv" "zshrc")
        for rcfile in ${ZSHFILES[@]}; do
            name=$(basename $rcfile)
            remove_rcfiles_symlink "${ZDOTDIR:-$HOME}/.${name}"
        done

        for item in ${SYMLINKS[@]}; do
            remove_rcfiles_symlink $item
        done
        unset item
}

uninstall_plugins() {
    echo "Remove fzf and zprezto directory"
    if [[ -e $HOME/.fzf/uninstall ]]; then
        $HOME/.fzf/uninstall
    fi
    \rm -rf $ZPREZTODIR
    \rm -rf $FZFDIR
    \rm -rf $OHMYZSHDIR
}

git_configulation() {
    git config --global core.editor vim
    git config --global alias.graph "log --graph --date=local --pretty=format:'%C(auto)%h%d%n %s %C(magenta)(%cd)%n %C(green)Committer:%cN <%cE>%n %C(blue)Author   :%aN <%aE>%Creset'"
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
    set +e
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
            sed --in-place --follow-symlinks "1s/^/$line\n/" $file
            echo "    + Added"
        else
            echo "    ~ Skipped"
        fi
    fi
    set +e
}

deploy_ohmyzsh_files() {
    echo -e "\n===== Install oh my zsh ==============================================\n"

    # restore zshrc backup if exists
    if [[ -e "$HOME/.zshrc.bak0" ]]; then
        if [[ -e "$HOME/.zshrc" ]]; then
            read -r -p ".zshrc already exists. Overwrite with .zshrc.bak0? [y/N] " response
            case "$response" in
                [yY][eE][sS]|[yY]) 
                    echo "Restore backup of zshrc"
                    cat ~/.zshrc.bak0 > ~/.zshrc
                    ;;
                *)  ;;
            esac
        else
            echo "Restore backup of zshrc"
            cat ~/.zshrc.bak0 > ~/.zshrc
        fi
    fi

    if [[ ! -e ${OHMYZSHDIR}/custom/themes/lambda-mod-mod.zsh-theme ]]; then
        ln -s $MYDOTFILES/zsh/lambda-mod-mod.zsh-theme ${OHMYZSHDIR}/custom/themes/
    fi

    # append line if zshrc doesn't has below line
    append_line 1 "source $MYDOTFILES/zsh/zshrc" "$HOME/.zshrc"
    insert_line 1 "skip_global_compinit=1" "$HOME/.zshenv"
}

deploy_selfmade_rcfiles() {
    # make symlinks
    echo -e "\n===== Install RC files ===============================================\n"
    final_idx_simlinks=`expr ${#SYMLINKS[@]} - 1`
    for i in `seq 0 ${final_idx_simlinks}`; do
        if [[ ! -e ${SYMLINKS[${i}]} ]]; then
            touch ${SYMTARGET[${i}]}
            ln -s ${SYMTARGET[${i}]} ${SYMLINKS[${i}]}
            echo "Made link: ${SYMLINKS[${i}]}"
            echo "       to: ${SYMTARGET[${i}]}"
        else
            echo "${SYMLINKS[${i}]} already exists!!"
        fi
    done
}

deploy_fzf() {
    echo -e "\n===== Install fzf ====================================================\n"
    ~/.fzf/install --completion --key-bindings --update-rc
}

##############################################
#               MAIN COMMANDS                #
##############################################

backup() {
        echo -e "\n===== Back up ========================================================\n"
    if [[ -e $ZSHRC ]]; then
        backup_file $ZSHRC
    fi
    for item in ${SYMLINKS[@]}; do
        if [[ -e $item ]]; then
            backup_file $item
        fi
    done
}

deploy() {
    deploy_ohmyzsh_files
    deploy_selfmade_rcfiles
    deploy_fzf
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
# else
#     debug function
#     backup_file $2
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
