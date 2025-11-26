#!/usr/bin/env bash
# vim: sw=4 sts=4 et :
#
# install.sh
# Copyright (C) 2018 ishitaku5522
#
# Distributed under terms of the MIT license.

set -eu
source "$(dirname "$0")/utils.sh"

if [ -z "$TERM" ]; then
    export TERM=xterm
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1; pwd -P)"

export DOTFILES_VERSION="0.1.0"

export MYDOTFILES="${SCRIPT_DIR}"
export MYDOTFILES_LITERAL='${SCRIPT_DIR}'
if type cygpath > /dev/null 2>&1; then
    export MYVIMRUNTIME=$HOME/vimfiles
else
    export MYVIMRUNTIME=$HOME/.vim
fi
export VADER_OUTPUT_FILE=./test_result.log

if [ ! -z ${ZSH_NAME:-} ];then
    setopt localoptions ksharrays
    echo "runnning on zsh"
fi

# directories
FZFDIR="$HOME/.fzf"
OHMYZSHDIR="$HOME/.oh-my-zsh"
TMUXPLUGINSDIR="$HOME/.tmux/plugins"
TMUXTPMDIR="$TMUXPLUGINSDIR/tpm"

# symlinks
ZSHRC="$HOME/.zshrc"

VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"
TMUXCONF="$HOME/.tmux.conf"
FLAKE8="$HOME/.config/flake8"
VINTRC="$HOME/.vintrc.yml"
EMACSINIT="$HOME/.spacemacs"
TIGRC="$HOME/.tigrc"
if [[ $OSTYPE == 'msys' ]]; then
    NVIMRC="$USERPROFILE/AppData/Local/nvim/init.lua"
    GNVIMRC="$USERPROFILE/AppData/Local/nvim/ginit.vim"
else
    NVIMRC="$HOME/.config/nvim/init.lua"
    GNVIMRC="$HOME/.config/nvim/ginit.vim"
fi
ALACRITTYRC=$HOME/.config/alacritty/alacritty.toml
WEZTERMRC=$HOME/.wezterm.lua
MCPHUB_SERVERS="$HOME/.config/mcphub/servers.json"

SYMLINKS=(
    "${FLAKE8}"
    "${VINTRC}"
    "${EMACSINIT}"
    "${NVIMRC}"
    "${GNVIMRC}"
    "${TIGRC}"
    "${ALACRITTYRC}"
    "${WEZTERMRC}"
    "${MCPHUB_SERVERS}"
)

SYMTARGET=(
    "${MYDOTFILES}/python/lint/flake8"
    "${MYDOTFILES}/python/lint/vintrc.yml"
    "${MYDOTFILES}/emacs/spacemacs"
    "${MYDOTFILES}/vim/init.lua"
    "${MYDOTFILES}/vim/ginit.vim"
    "${MYDOTFILES}/tig/tigrc"
    "${MYDOTFILES}/alacritty/alacritty.toml"
    "${MYDOTFILES}/wezterm/.wezterm.lua"
    "${MYDOTFILES}/mcphub/servers.json"
)

# actual files
LOCALRCSDIR="$HOME/localrcs"
LOCALRCS=(
    "$LOCALRCSDIR/tmux-local"
    "$LOCALRCSDIR/vim-local.vim"
    "$LOCALRCSDIR/zsh-local.zsh"
)
TRASH="$HOME/.trash"

if type gsed > /dev/null 2>&1; then
    alias sed="gsed"
fi

. ./help.sh


ascii_art() {
    cat << EOF

[38;2;102;126;234m [38;2;102;125;233m█[38;2;102;125;232m█[38;2;103;124;231m█[38;2;103;123;230m█[38;2;103;122;229m█[38;2;103;122;228m█[38;2;104;121;227m╗[38;2;104;120;226m [38;2;104;119;224m [38;2;104;119;223m [38;2;105;118;222m█[38;2;105;117;221m█[38;2;105;116;220m█[38;2;105;116;219m█[38;2;106;115;218m█[38;2;106;114;217m█[38;2;106;113;216m╗[38;2;106;113;215m [38;2;106;112;214m [38;2;107;111;213m█[38;2;107;110;212m█[38;2;107;110;211m█[38;2;107;109;210m█[38;2;108;108;209m█[38;2;108;107;208m█[38;2;108;107;206m█[38;2;108;106;205m█[38;2;109;105;204m╗[38;2;109;104;203m [38;2;109;104;202m█[38;2;109;103;201m█[38;2;110;102;200m█[38;2;110;101;199m█[38;2;110;101;198m█[38;2;110;100;197m█[38;2;110;99;196m█[38;2;111;98;195m╗[38;2;111;98;194m [38;2;111;97;193m█[38;2;111;96;192m█[38;2;112;95;191m╗[38;2;112;95;190m [38;2;112;94;188m█[38;2;112;93;187m█[38;2;113;92;186m╗[38;2;113;92;185m [38;2;113;91;184m [38;2;113;90;183m [38;2;114;89;182m [38;2;114;89;181m [38;2;114;88;180m [38;2;114;87;179m█[38;2;114;86;178m█[38;2;115;86;177m█[38;2;115;85;176m█[38;2;115;84;175m█[38;2;115;83;174m█[38;2;116;83;173m█[38;2;116;82;172m╗[38;2;116;81;170m [38;2;116;80;169m█[38;2;117;80;168m█[38;2;117;79;167m█[38;2;117;78;166m█[38;2;117;77;165m█[38;2;118;77;164m█[38;2;118;76;163m█[38;2;118;75;162m╗[39m
[38;2;102;126;234m [38;2;102;125;233m█[38;2;102;125;232m█[38;2;103;124;231m╔[38;2;103;123;230m═[38;2;103;122;229m═[38;2;103;122;228m█[38;2;104;121;227m█[38;2;104;120;226m╗[38;2;104;119;224m [38;2;104;119;223m█[38;2;105;118;222m█[38;2;105;117;221m╔[38;2;105;116;220m═[38;2;105;116;219m═[38;2;106;115;218m═[38;2;106;114;217m█[38;2;106;113;216m█[38;2;106;113;215m╗[38;2;106;112;214m [38;2;107;111;213m╚[38;2;107;110;212m═[38;2;107;110;211m═[38;2;107;109;210m█[38;2;108;108;209m█[38;2;108;107;208m╔[38;2;108;107;206m═[38;2;108;106;205m═[38;2;109;105;204m╝[38;2;109;104;203m [38;2;109;104;202m█[38;2;109;103;201m█[38;2;110;102;200m╔[38;2;110;101;199m═[38;2;110;101;198m═[38;2;110;100;197m═[38;2;110;99;196m═[38;2;111;98;195m╝[38;2;111;98;194m [38;2;111;97;193m█[38;2;111;96;192m█[38;2;112;95;191m║[38;2;112;95;190m [38;2;112;94;188m█[38;2;112;93;187m█[38;2;113;92;186m║[38;2;113;92;185m [38;2;113;91;184m [38;2;113;90;183m [38;2;114;89;182m [38;2;114;89;181m [38;2;114;88;180m [38;2;114;87;179m█[38;2;114;86;178m█[38;2;115;86;177m╔[38;2;115;85;176m═[38;2;115;84;175m═[38;2;115;83;174m═[38;2;116;83;173m═[38;2;116;82;172m╝[38;2;116;81;170m [38;2;116;80;169m█[38;2;117;80;168m█[38;2;117;79;167m╔[38;2;117;78;166m═[38;2;117;77;165m═[38;2;118;77;164m═[38;2;118;76;163m═[38;2;118;75;162m╝[39m
[38;2;102;126;234m [38;2;102;125;233m█[38;2;102;125;232m█[38;2;103;124;231m║[38;2;103;123;230m [38;2;103;122;229m [38;2;103;122;228m█[38;2;104;121;227m█[38;2;104;120;226m║[38;2;104;119;224m [38;2;104;119;223m█[38;2;105;118;222m█[38;2;105;117;221m║[38;2;105;116;220m [38;2;105;116;219m [38;2;106;115;218m [38;2;106;114;217m█[38;2;106;113;216m█[38;2;106;113;215m║[38;2;106;112;214m [38;2;107;111;213m [38;2;107;110;212m [38;2;107;110;211m [38;2;107;109;210m█[38;2;108;108;209m█[38;2;108;107;208m║[38;2;108;107;206m [38;2;108;106;205m [38;2;109;105;204m [38;2;109;104;203m [38;2;109;104;202m█[38;2;109;103;201m█[38;2;110;102;200m█[38;2;110;101;199m█[38;2;110;101;198m█[38;2;110;100;197m╗[38;2;110;99;196m [38;2;111;98;195m [38;2;111;98;194m [38;2;111;97;193m█[38;2;111;96;192m█[38;2;112;95;191m║[38;2;112;95;190m [38;2;112;94;188m█[38;2;112;93;187m█[38;2;113;92;186m║[38;2;113;92;185m [38;2;113;91;184m [38;2;113;90;183m [38;2;114;89;182m [38;2;114;89;181m [38;2;114;88;180m [38;2;114;87;179m█[38;2;114;86;178m█[38;2;115;86;177m█[38;2;115;85;176m█[38;2;115;84;175m█[38;2;115;83;174m╗[38;2;116;83;173m [38;2;116;82;172m [38;2;116;81;170m [38;2;116;80;169m█[38;2;117;80;168m█[38;2;117;79;167m█[38;2;117;78;166m█[38;2;117;77;165m█[38;2;118;77;164m█[38;2;118;76;163m█[38;2;118;75;162m╗[39m
[38;2;102;126;234m [38;2;102;125;233m█[38;2;102;125;232m█[38;2;103;124;231m║[38;2;103;123;230m [38;2;103;122;229m [38;2;103;122;228m█[38;2;104;121;227m█[38;2;104;120;226m║[38;2;104;119;224m [38;2;104;119;223m█[38;2;105;118;222m█[38;2;105;117;221m║[38;2;105;116;220m [38;2;105;116;219m [38;2;106;115;218m [38;2;106;114;217m█[38;2;106;113;216m█[38;2;106;113;215m║[38;2;106;112;214m [38;2;107;111;213m [38;2;107;110;212m [38;2;107;110;211m [38;2;107;109;210m█[38;2;108;108;209m█[38;2;108;107;208m║[38;2;108;107;206m [38;2;108;106;205m [38;2;109;105;204m [38;2;109;104;203m [38;2;109;104;202m█[38;2;109;103;201m█[38;2;110;102;200m╔[38;2;110;101;199m═[38;2;110;101;198m═[38;2;110;100;197m╝[38;2;110;99;196m [38;2;111;98;195m [38;2;111;98;194m [38;2;111;97;193m█[38;2;111;96;192m█[38;2;112;95;191m║[38;2;112;95;190m [38;2;112;94;188m█[38;2;112;93;187m█[38;2;113;92;186m║[38;2;113;92;185m [38;2;113;91;184m [38;2;113;90;183m [38;2;114;89;182m [38;2;114;89;181m [38;2;114;88;180m [38;2;114;87;179m█[38;2;114;86;178m█[38;2;115;86;177m╔[38;2;115;85;176m═[38;2;115;84;175m═[38;2;115;83;174m╝[38;2;116;83;173m [38;2;116;82;172m [38;2;116;81;170m [38;2;116;80;169m╚[38;2;117;80;168m═[38;2;117;79;167m═[38;2;117;78;166m═[38;2;117;77;165m═[38;2;118;77;164m█[38;2;118;76;163m█[38;2;118;75;162m║[39m
[38;2;102;126;234m [38;2;102;125;233m█[38;2;102;125;232m█[38;2;103;124;231m█[38;2;103;123;230m█[38;2;103;122;229m█[38;2;103;122;228m█[38;2;104;121;227m╔[38;2;104;120;226m╝[38;2;104;119;224m [38;2;104;119;223m╚[38;2;105;118;222m█[38;2;105;117;221m█[38;2;105;116;220m█[38;2;105;116;219m█[38;2;106;115;218m█[38;2;106;114;217m█[38;2;106;113;216m╔[38;2;106;113;215m╝[38;2;106;112;214m [38;2;107;111;213m [38;2;107;110;212m [38;2;107;110;211m [38;2;107;109;210m█[38;2;108;108;209m█[38;2;108;107;208m║[38;2;108;107;206m [38;2;108;106;205m [38;2;109;105;204m [38;2;109;104;203m [38;2;109;104;202m█[38;2;109;103;201m█[38;2;110;102;200m║[38;2;110;101;199m [38;2;110;101;198m [38;2;110;100;197m [38;2;110;99;196m [38;2;111;98;195m [38;2;111;98;194m [38;2;111;97;193m█[38;2;111;96;192m█[38;2;112;95;191m║[38;2;112;95;190m [38;2;112;94;188m█[38;2;112;93;187m█[38;2;113;92;186m█[38;2;113;92;185m█[38;2;113;91;184m█[38;2;113;90;183m█[38;2;114;89;182m█[38;2;114;89;181m╗[38;2;114;88;180m [38;2;114;87;179m█[38;2;114;86;178m█[38;2;115;86;177m█[38;2;115;85;176m█[38;2;115;84;175m█[38;2;115;83;174m█[38;2;116;83;173m█[38;2;116;82;172m╗[38;2;116;81;170m [38;2;116;80;169m█[38;2;117;80;168m█[38;2;117;79;167m█[38;2;117;78;166m█[38;2;117;77;165m█[38;2;118;77;164m█[38;2;118;76;163m█[38;2;118;75;162m║[39m
[38;2;102;126;234m [38;2;102;125;233m╚[38;2;102;125;232m═[38;2;103;124;231m═[38;2;103;123;230m═[38;2;103;122;229m═[38;2;103;122;228m═[38;2;104;121;227m╝[38;2;104;120;226m [38;2;104;119;224m [38;2;104;119;223m [38;2;105;118;222m╚[38;2;105;117;221m═[38;2;105;116;220m═[38;2;105;116;219m═[38;2;106;115;218m═[38;2;106;114;217m═[38;2;106;113;216m╝[38;2;106;113;215m [38;2;106;112;214m [38;2;107;111;213m [38;2;107;110;212m [38;2;107;110;211m [38;2;107;109;210m╚[38;2;108;108;209m═[38;2;108;107;208m╝[38;2;108;107;206m [38;2;108;106;205m [38;2;109;105;204m [38;2;109;104;203m [38;2;109;104;202m╚[38;2;109;103;201m═[38;2;110;102;200m╝[38;2;110;101;199m [38;2;110;101;198m [38;2;110;100;197m [38;2;110;99;196m [38;2;111;98;195m [38;2;111;98;194m [38;2;111;97;193m╚[38;2;111;96;192m═[38;2;112;95;191m╝[38;2;112;95;190m [38;2;112;94;188m╚[38;2;112;93;187m═[38;2;113;92;186m═[38;2;113;92;185m═[38;2;113;91;184m═[38;2;113;90;183m═[38;2;114;89;182m═[38;2;114;89;181m╝[38;2;114;88;180m [38;2;114;87;179m╚[38;2;114;86;178m═[38;2;115;86;177m═[38;2;115;85;176m═[38;2;115;84;175m═[38;2;115;83;174m═[38;2;116;83;173m═[38;2;116;82;172m╝[38;2;116;81;170m [38;2;116;80;169m╚[38;2;117;80;168m═[38;2;117;79;167m═[38;2;117;78;166m═[38;2;117;77;165m═[38;2;118;77;164m═[38;2;118;76;163m═[38;2;118;75;162m╝[39m

EOF
sleep 1
}

echo_section() {
    # print section log
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

    local old_cwd=$(pwd)

    echo "Upgrading dotfiles repository"
    git --git-dir=${MYDOTFILES}/.git --work-tree=${MYDOTFILES} pull

    echo "Upgrading fzf repository"
    git --git-dir=${FZFDIR}/.git --work-tree=${FZFDIR} pull

    echo "Upgrading oh-my-zsh repository"
    cd ${OHMYZSHDIR}
    set +e
    ./tools/upgrade.sh
    set -e

    # if not newest (80) or upgraded (0), exit as error
    if [[ ! ($? == 80 || $? == 0) ]];then
        exit $?
    fi

    echo "Upgrading oh-my-zsh plugins"
    echo "  Upgrading zsh-syntax-highlighting"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/zsh-syntax-highlighting/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-syntax-highlighting/ \
        pull &

    echo "  Upgrading zsh-autosuggestions"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/zsh-autosuggestions/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-autosuggestions/ \
        pull &

    echo "  Upgrading zsh-completions"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/zsh-completions/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-completions/ \
        pull &

    echo "  Upgrading zsh-defer"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/zsh-defer/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/zsh-defer/ \
        pull &

    echo "  Upgrading pyenv-lazy"
    git --git-dir=${OHMYZSHDIR}/custom/plugins/pyenv-lazy/.git \
        --work-tree=${OHMYZSHDIR}/custom/plugins/pyenv-lazy/ \
        pull &

    wait

    echo "Upgrading tmux tpm repository"
    git --git-dir=${TMUXTPMDIR}/.git --work-tree=${TMUXTPMDIR} pull

    cd ${old_cwd}
}





remove_rcfiles() {
    echo_section "Removeing existing RC files"
    delete_line 1 "source $MYDOTFILES/zsh/zshrc.zsh" "$HOME/.zshrc"
    delete_line 1 "if (which zprof > /dev/null) ;then zprof; fi" "$HOME/.zshrc"
    delete_line 1 "# zmodload zsh\/zprof \&\& zprof" "$HOME/.zshrc" "zmodload zsh/zprof"
    delete_line 1 "# zmodload zsh\/zprof \&\& zprof" "$HOME/.zshenv" "zmodload zsh/zprof"
    delete_line 1 "skip_global_compinit=1" "$HOME/.zshenv"

    vimrc_path=$MYDOTFILES/vim/vimrc.vim
    gvimrc_path=$MYDOTFILES/vim/gvimrc.vim
    delete_line 1 "source ${vimrc_path}" ${VIMRC}
    delete_line 1 "source ${gvimrc_path}" ${GVIMRC}

    for item in ${SYMLINKS[@]}; do
        remove_rcfiles_symlink $item
    done
    unset item
}

uninstall_plugins() {
    echo "Removing plugin directories"
    if [[ -e $FZFDIR/uninstall ]]; then
        $FZFDIR/uninstall
    fi
    \rm -rf $FZFDIR
    \rm -rf $OHMYZSHDIR
    \rm -rf $TMUXTPMDIR
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
    local old_cwd=$(pwd)

    # Install fzf
    if [[ ! -e ${FZFDIR} ]]; then
        echo_section "Downloading fzf"
        git clone --depth 1 https://github.com/junegunn/fzf.git $FZFDIR &
    fi

    # Install oh-my-zsh
    if [[ ! -e ${OHMYZSHDIR} ]]; then
        echo_section "Downloading oh my zsh"
        git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git $OHMYZSHDIR

    fi

    cd $OHMYZSHDIR/custom/plugins

    if [[ ! -e ${OHMYZSHDIR}/custom/plugins/zsh-syntax-highlighting ]]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting &
    fi
    if [[ ! -e ${OHMYZSHDIR}/custom/plugins/zsh-autosuggestions ]]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions &
    fi
    if [[ ! -e ${OHMYZSHDIR}/custom/plugins/zsh-completions ]]; then
        git clone --depth 1 https://github.com/zsh-users/zsh-completions &
    fi
    if [[ ! -e ${OHMYZSHDIR}/custom/plugins/zsh-defer ]]; then
        git clone --depth 1 https://github.com/romkatv/zsh-defer &
    fi
    if [[ ! -e ${OHMYZSHDIR}/custom/plugins/pyenv-lazy ]]; then
        git clone --depth 1 https://github.com/davidparsson/zsh-pyenv-lazy pyenv-lazy &
    fi

    wait

    cd ${old_cwd}

    if [[ ! -e ${OHMYZSHDIR}/custom/themes ]]; then
        mkdir -p ${OHMYZSHDIR}/custom/themes
    fi

    # Install tmux tpm
    if [[ ! -e ${TMUXTPMDIR} ]]; then
        git clone --depth 1 https://github.com/tmux-plugins/tpm $TMUXTPMDIR
    fi
}








deploy_ohmyzsh_files() {
    echo_section "Installing oh my zsh"

    if [[ ! -e ${OHMYZSHDIR}/custom/themes/ishitaku.zsh-theme ]]; then
        ln -s $MYDOTFILES/zsh/ishitaku.zsh-theme ${OHMYZSHDIR}/custom/themes/
    fi

    # append line if zshrc doesn't has below line
    append_line 1 "source $MYDOTFILES/zsh/zshrc.zsh" "$HOME/.zshrc"
    append_line 1 "if (which zprof > /dev/null) ;then zprof; fi" "$HOME/.zshrc"
    insert_line 1 "skip_global_compinit=1" "$HOME/.zshenv"
    insert_line 1 "# zmodload zsh\/zprof \&\& zprof" "$HOME/.zshrc" "zmodload zsh/zprof"
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
            echo "Making link: ${SYMLINKS[${i}]}"
            echo "           --> ${SYMTARGET[${i}]}"
            ln -s ${SYMTARGET[${i}]} ${SYMLINKS[${i}]}
        else
            echo "${SYMLINKS[${i}]} already exists!!"
        fi
    done

    if [[ -L $VIMRC ]]; then
        echo "Removing symlink: $VIMRC"
        \unlink $VIMRC
    fi
    if [[ -L $GVIMRC ]]; then
        echo "Removing symlink: $GVIMRC"
        \unlink $GVIMRC
    fi
    if [[ -L $TMUXCONF ]]; then
        echo "Removing symlink: $TMUXCONF"
        \unlink $TMUXCONF
    fi

    vimrc_path=$MYDOTFILES/vim/vimrc.vim
    gvimrc_path=$MYDOTFILES/vim/gvimrc.vim

    if type cygpath > /dev/null 2>&1; then
        cyg_vimrc_path=$(cygpath -w ${vimrc_path})
        cyg_gvimrc_path=$(cygpath -w ${gvimrc_path})

        vimrc_line="if !has('win32') | source ${vimrc_path} | else | source ${cyg_vimrc_path} | endif"
        gvimrc_line="if !has('win32') | source ${gvimrc_path} | else | source ${cyg_gvimrc_path} | endif"

    else
        vimrc_line="source ${vimrc_path}"
        gvimrc_line="source ${gvimrc_path}"
    fi

    tmux_conf_line="source $MYDOTFILES/tmux/common.tmux.conf"

    append_line 1 "${vimrc_line}" ${VIMRC}
    append_line 1 "${gvimrc_line}" ${GVIMRC}
    append_line 1 "${tmux_conf_line}" ${TMUXCONF}
}

deploy_fzf() {
    echo_section "Installing fzf"
    $FZFDIR/install --completion --key-bindings --no-update-rc
}

##############################################
#               MAIN COMMANDS                #
##############################################

backup() {
    echo_section "Making back up files"

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

install_essential_dependencies() {
    local deps=''
    if ! (type git > /dev/null 2>&1); then
        deps="${deps} git"
    fi
    if ! (type vim > /dev/null 2>&1); then
        deps="${deps} vim"
    fi
    if ! (type tmux > /dev/null 2>&1); then
        deps="${deps} tmux"
    fi
    if ! (type zsh > /dev/null 2>&1); then
        deps="${deps} zsh"
    fi

    if type apt-get > /dev/null 2>&1; then
        # Ubuntu has mawk as default and this replace it.
        if ! (type gawk > /dev/null 2>&1); then
            deps="${deps} gawk"
        fi
    fi

    install_deps "essential softwares" "${deps}" ""

    clone_dotfiles_repository
}



# Ensure Bats helper libraries are present before any test run. This function can be called explicitly or from other steps.
setup_bats_helpers() {
    # Clone the helpers if they are missing – idempotent operation.
    if [ ! -d "tests/test_helper/bats-support" ]; then
        git clone https://github.com/bats-core/bats-support.git tests/test_helper/bats-support
    fi
    if [ ! -d "tests/test_helper/bats-assert" ]; then
        git clone https://github.com/bats-core/bats-assert.git tests/test_helper/bats-assert
    fi
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

install_vim_plugins() {
    echo_section "Installing vim plugins"

    if type git > /dev/null 2>&1; then 
        if [[ -d $MYDOTFILES/build/vim ]]; then
            export PATH=$MYDOTFILES/build/vim/bin/:$PATH
        fi
        if type vim > /dev/null 2>&1; then
            vim --not-a-term --version
            echo "Running :PlugInstall"
            vim --not-a-term \
                --cmd 'let g:is_test = 1' \
                --cmd 'set shortmess=a cmdheight=10' \
                --cmd 'cal feedkeys("\<CR>\<CR>\<CR>\<CR>\<CR>")' \
                -c ':PlugInstall --sync' \
                -c ':qa!'
        fi
        if [[ -d $MYDOTFILES/build/neovim ]]; then
            export PATH=$MYDOTFILES/build/neovim/bin/:$PATH
        fi
        if type nvim > /dev/null 2>&1; then
            nvim --version
            echo "Running :PlugInstall"
            nvim --cmd 'let g:is_test = 1 | set shortmess=a cmdheight=10' \
                --cmd 'cal feedkeys("\<CR>\<CR>\<CR>\<CR>\<CR>")' \
                -c ':PlugInstall --sync' \
                -c ':Lazy update' \
                -c ':qa!'
        fi
    fi
    echo "Installed."
}

install_tmux_plugins() {
    echo_section "Installing tmux plugins"
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"
}


update_vim_plugins() {
    echo_section "Updating vim plugins"
    if type git > /dev/null 2>&1; then
        if [[ -d $MYDOTFILES/build/vim ]]; then
            export PATH=$MYDOTFILES/build/vim/bin/:$PATH
        fi
        if type vim > /dev/null 2>&1; then
            if [[ -d $MYVIMRUNTIME/plugged ]] || [[ -d $MYVIMRUNTIME/pack ]]; then
                vim --not-a-term -T xterm-256color --version
                echo "Running :PlugUpgrade, :PlugUpdate"
                vim --not-a-term \
                    --cmd 'let g:is_test = 1 | set shortmess=a cmdheight=10' \
                    --cmd 'cal feedkeys("\<CR>\<CR>\<CR>\<CR>\<CR>")' \
                    -c ':PlugUpgrade' \
                    -c ':PlugUpdate --sync' \
                    -c ':qa!'
            fi
        fi
        if [[ -d $MYDOTFILES/build/neovim ]]; then
            export PATH=$MYDOTFILES/build/neovim/bin/:$PATH
        fi
        if type nvim > /dev/null 2>&1; then
            if [[ -d $MYVIMRUNTIME/plugged ]] || [[ -d $MYVIMRUNTIME/pack ]]; then
                nvim --version
                echo "Running :PlugUpgrade, :PlugUpdate"
                nvim --cmd 'let g:is_test = 1 | set shortmess=a cmdheight=10' \
                    --cmd 'cal feedkeys("\<CR>\<CR>\<CR>\<CR>\<CR>")' \
                    -c ':PlugUpgrade' \
                    -c ':PlugUpdate --sync' \
                    -c ':Lazy update' \
                    -c ':qa!'
            fi
        fi
    fi
    echo "Updated."
}

update_tmux_plugins() {
    echo_section "Updating tmux plugins"
    "$HOME/.tmux/plugins/tpm/scripts/update_plugin.sh" -- all
}

install_deps() {
    local msg=$1
    local deps=$2
    local curl_deps=$3
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

    if [[ $OSTYPE == 'darwin'* ]]; then
        brew update
        brew upgrade
        brew install ${deps}
    elif [[ $(lsb_release -rs) == "18.04" ]]; then
        ${sudo} apt-get update
        ${sudo} apt-get upgrade -y
        ${sudo} apt-get install -y ${deps}
    elif [[ $(lsb_release -rs) == "20.04" ]]; then
        ${sudo} apt-get update
        ${sudo} apt-get upgrade -y
        ${sudo} apt-get install -y ${deps}
    elif [[ $(lsb_release -rs) == "22.04" ]]; then
        ${sudo} apt-get update
        ${sudo} apt-get upgrade -y
        ${sudo} apt-get install -y ${deps}
    elif type apt-get > /dev/null 2>&1; then
        ${sudo} apt-get update
        ${sudo} apt-get upgrade -y
        ${sudo} apt-get install -y ${deps}
    elif type cygpath > /dev/null 2>&1; then
        # Do nothing on cygwin
        :
    elif type dnf > /dev/null 2>&1; then
        ${sudo} dnf update -y
        ${sudo} dnf install -y ${deps} || true
    elif type yum > /dev/null 2>&1; then
        ${sudo} yum update
        if cat /etc/redhat-release | grep " 7."; then
            # Cent/RHEL 7
            if ${sudo} yum list installed git2u >/dev/null 2>&1; then
                :
            else
                ${sudo} yum remove git* -y
            fi
            ${sudo} yum install -y https://centos7.iuscommunity.org/ius-release.rpm || true
        fi
        ${sudo} yum install -y ${deps} || true
    fi

    for url in $curl_deps; do
        curl -fsSL $url | sh -s -- --yes
    done
}

build_vim_install_deps() {
local deps=""
local curl_deps=""
local tmp_deps=""
if [[ $OSTYPE == 'darwin'* ]]; then
    tmp_deps='lua luajit automake python3 pkg-config utf8proc'
    curl_deps='https://deno.land/install.sh'

    package_list_tmpfile=$(mktemp)
    brew ls -1 > "$package_list_tmpfile"
    for package in ${tmp_deps}; do
        if ! cat $package_list_tmpfile | grep -Fxq "$package" > /dev/null 2>&1; then
            deps="${deps} ${package}"
        fi
    done
    rm -f $package_list_tmpfile
elif [[ $(lsb_release -rs) == "20.04" ]]; then
    tmp_deps='git gettext libtinfo-dev libacl1-dev libgpm-dev build-essential libncurses5-dev libncursesw5-dev python3-dev ruby-dev lua5.1 liblua5.1-0-dev luajit libluajit-5.1-2 libutf8proc-dev'
    for package in ${tmp_deps}; do
        if ! dpkg -s ${package} > /dev/null 2>&1; then
            deps="${deps} ${package}"
        fi
    done
    curl_deps='https://deno.land/install.sh'
elif [[ $(lsb_release -rs) == "22.04" ]]; then
    tmp_deps='git gettext libtinfo-dev libacl1-dev libgpm-dev build-essential libncurses5-dev libncursesw5-dev python3-dev ruby-dev lua5.1 liblua5.1-0-dev luajit libluajit-5.1-2 libutf8proc-dev'
    for package in ${tmp_deps}; do
        if ! dpkg -s ${package} > /dev/null 2>&1; then
            deps="${deps} ${package}"
        fi
    done
    curl_deps='https://deno.land/install.sh'
elif [[ $(lsb_release -rs) == "24.04" ]]; then
    tmp_deps='git gettext libtinfo-dev libacl1-dev libgpm-dev build-essential libncurses5-dev libncursesw5-dev python3-dev ruby-dev lua5.1 liblua5.1-0-dev luajit libluajit-5.1-2 libutf8proc-dev'
    for package in ${tmp_deps}; do
        if ! dpkg -s ${package} > /dev/null 2>&1; then
            deps="${deps} ${package}"
        fi
    done
    curl_deps='https://deno.land/install.sh'
elif type dnf > /dev/null 2>&1; then
    deps='git gcc make ncurses ncurses-devel tcl-devel ruby ruby-devel lua lua-devel luajit luajit-devel python3 python3-devel utf8proc utf8proc-devel'
    curl_deps='https://deno.land/install.sh'
elif type yum > /dev/null 2>&1; then
    deps='git2u gcc make ncurses ncurses-devel tcl-devel ruby ruby-devel lua lua-devel luajit luajit-devel python3 python3-devel utf8proc'
    curl_deps='https://deno.land/install.sh'
fi
install_deps "vim build" "${deps}" "${curl_deps}"
}

build_neovim_install_deps() {
    local deps=""
    local curl_deps=""
    local tmp_deps=""
    if [[ $OSTYPE == 'darwin'* ]]; then
        tmp_deps='cmake'

        package_list_tmpfile=$(mktemp)
        brew ls -1 > "$package_list_tmpfile"
        for package in ${tmp_deps}; do
            if ! cat $package_list_tmpfile | grep -Fxq "$package" > /dev/null 2>&1; then
                deps="${deps} ${package}"
            fi
        done
        rm -f $package_list_tmpfile
    elif [[ $(lsb_release -rs) == "20.04" ]]; then
        tmp_deps='cmake'
        for package in ${tmp_deps}; do
            if ! dpkg -s ${package} > /dev/null 2>&1; then
                deps="${deps} ${package}"
            fi
        done
    elif [[ $(lsb_release -rs) == "22.04" ]]; then
        tmp_deps='cmake'
        for package in ${tmp_deps}; do
            if ! dpkg -s ${package} > /dev/null 2>&1; then
                deps="${deps} ${package}"
            fi
        done
    elif [[ $(lsb_release -rs) == "24.04" ]]; then
        tmp_deps='cmake'
        for package in ${tmp_deps}; do
            if ! dpkg -s ${package} > /dev/null 2>&1; then
                deps="${deps} ${package}"
            fi
        done
    elif type dnf > /dev/null 2>&1; then
        deps='cmake'
    elif type yum > /dev/null 2>&1; then
        deps='cmake'
    fi
    install_deps "neovim build" "${deps}" "${curl_deps}"
}

build_tmux_install_deps() {
local deps=""
local tmp_deps=""
if type apt-get > /dev/null 2>&1; then
    tmp_deps='git automake pkg-config libevent-dev libncurses5-dev libncursesw5-dev bison'
    for package in ${tmp_deps}
    do
        if ! dpkg -s ${package} > /dev/null 2>&1; then
            deps="${deps} ${package}"
        fi
    done
elif type dnf > /dev/null 2>&1; then
    deps='git automake libevent-devel ncurses-devel make gcc byacc'
elif type yum > /dev/null 2>&1; then
    deps='git2u automake libevent-devel ncurses-devel make gcc byacc'
    fi
    install_deps "tmux build" "${deps}" ""
}

make_install() {
    local script=$1
    local repo=$2

    if [[ ! -d $MYDOTFILES/build ]]; then
        mkdir -p $MYDOTFILES/build
    fi

    pushd $MYDOTFILES/build
    if [[ ! -e ./myconfigure_setup.sh ]]; then
        ln -s $MYDOTFILES/tools/myconfigure_setup.sh ./myconfigure_setup.sh
    fi
    if [[ ! -e ${script} ]]; then
        ln -s $MYDOTFILES/tools/${script} ./$script
        ls -la
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

build_neovim_make_install() {
    echo_section "Compiling neovim"
    make_install "neovim_myconfigure.sh" "https://github.com/neovim/neovim"
}

build_vim(){
    build_vim_install_deps
    build_vim_make_install
}

build_neovim(){
    build_neovim_install_deps
    build_neovim_make_install
}

build_tmux(){
    # automake pkg-config libevent-dev libncurses5-dev libncursesw5-dev
    build_tmux_install_deps
    build_tmux_make_install
}

uninstall_built_tools(){
    \unlink $MYDOTFILES/build/vim_myconfigure.sh
    \rm -rf $MYDOTFILES/build/vim
    \rm -rf $HOME/build/vim

    \unlink $MYDOTFILES/build/tmux_myconfigure.sh
    \rm -rf $MYDOTFILES/build/tmux
    \rm -rf $HOME/build/tmux
}

buildtools(){
    build_vim
    build_tmux
    build_tig_make_install
    build_neovim
}

create_localrc_dir() {
    # Not symlink
    if [[ ! -e ${LOCALRCSDIR} ]]; then
        mkdir -p ${LOCALRCSDIR}
    fi

    for rcfile in ${LOCALRCS[@]}; do
        if [[ ! -e ${rcfile} ]]; then
            touch ${rcfile}
            echo "made ${rcfile}"
        fi
    done
}

create_trash_dir() {
    if [[ ! -e ${TRASH} ]]; then
        mkdir ${TRASH}
    fi
}

deploy() {
    deploy_ohmyzsh_files
    deploy_selfmade_rcfiles
    deploy_fzf
    compile_zshfiles
    install_vim_plugins
    install_tmux_plugins
    git_configulation
    create_localrc_dir
    create_trash_dir

    echo $DOTFILES_VERSION > "$SCRIPT_DIR/deployed-version.txt"
}

undeploy() {
    remove_rcfiles
}

redeploy() {
    undeploy
    deploy
}

update() {
    if [ -z "${DOTFILES_UPDATED:-}" ]; then
        echo "Updating dotfiles"
        pushd $MYDOTFILES
            git pull
        popd
        export DOTFILES_UPDATED=true
        $0 update
    else
        update_repositories
        deploy
        update_vim_plugins
        update_tmux_plugins
    fi
}

install() {
    install_essential_dependencies
    download_plugin_repositories
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

runtest() {
    echo "SETTING UP ENVIRONMENT"
    # Install Bats testing framework and helpers for CI/tests
    if ! type bats > /dev/null 2>&1; then
        if type brew > /dev/null 2>&1; then
            deps="${deps} bats-core"
        elif type apt-get > /dev/null 2>&1; then
            deps="${deps} bats"
        fi
    fi
    setup_bats_helpers

    echo "STARTING TEST"

    pwd
    ls -la
    echo "ls -la ~/"
    ls -la ~/
    echo "ls -la ~/.config/nvim/"
    ls -la ~/.config/nvim/
    echo "ls -la ~/.vim/plugged/"
    ls -la ~/.vim/plugged/
    echo "ls -la ~/.deno"
    ls -la ~/.deno

    . $HOME/.deno/env
    export PATH=$HOME/.deno/bin:$PATH
    export PATH=$MYDOTFILES/build/neovim/bin:$PATH

    echo "Starting nvim test"

    pushd $MYDOTFILES/vim

    set +e

    nvim --headless -c "PlenaryBustedDirectory . { init = \"./init.lua\" }"
    return_code=$?

    set -e

    popd

    if [[ "$return_code" -ne 0 ]]; then
        echo "END TEST"
        echo "TEST FAILED: return_code is not 0"
        return $return_code
    fi

    # Run Bats tests for utils and other bash helpers
    echo "Running Bats tests"
    bats tests/
    bats_status=$?
    if [[ $bats_status -ne 0 ]]; then
        echo "END TEST"
        echo "BATS TEST FAILED (exit code $bats_status)"
        return $bats_status
    fi

    # echo "Starting vim test"

    # export THEMIS_ARGS="-e -s -u $HOME/.vimrc"
    # export THEMIS_DEBUG=1

    # pushd $MYDOTFILES/vim

    # set +e

    # # patch -N $HOME/.vim/plugged/vim-themis/bin/themis $MYDOTFILES/themis-patch.diff
    # $HOME/.vim/plugged/vim-themis/bin/themis --debug
    # return_code=$?

    # set -e

    # popd

    # if [[ "$return_code" -ne 0 ]]; then
    #     echo "END TEST"
    #     echo "TEST FAILED: return_code is not 0"
    #     return $return_code
    # fi

    # echo "Starting pytest"

    # if ! pytest --version; then
    #     if [[ ! -d ".venv" ]]; then
    #         python -m venv .venv
    #     fi
    #     source .venv/bin/activate
    #     if ! pytest --version; then
    #         python -m pip install -r ./requirements_test.txt
    #     fi
    # fi

    # set +e

    # pytest -v
    # return_code=$?

    # set -e

    # if [[ "$return_code" -ne 0 ]]; then
    #     echo "END TEST"
    #     echo "TEST FAILED: return_code is not 0"
    #     return $return_code
    # fi

    echo "END TEST"
    return $return_code
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
        buildtools)
            # case $2 in
            #     vim|neovim|tig|tmux|all)
            #         ;;
            #     *)
            #         buildtools_help
            #         ;;
            # esac
            ;;
        runtest)   ;;
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
