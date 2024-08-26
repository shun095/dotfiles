#!/usr/bin/env zsh
# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# GENERAL CONFIG
if [[ "${EDITOR}" = "" ]]; then
    export EDITOR=vim
fi
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/usr/bin:$PATH"

# golang
export GOPATH=$HOME/.gopath
export PATH="$HOME/build/go/bin:/usr/local/go/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

# ruby
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"

# node js
export PATH="$HOME/build/node/bin:$PATH"
export PATH="$HOME/.nodebrew/current/bin:$PATH"

export USE_CCACHE=1

# GENERAL
export MYDOTFILES=$HOME/dotfiles

# tools
export PATH="$HOME/Applications/MacVim.app/Contents/bin/:$PATH"
export PATH="$MYDOTFILES/build/emacs/bin:$PATH"
export PATH="$MYDOTFILES/build/tig/bin:$PATH"
export PATH="$MYDOTFILES/build/tmux/bin:$PATH"
export PATH="$MYDOTFILES/build/ctags/bin:$PATH"
export PATH="$MYDOTFILES/build/nvim-qt/bin:$PATH"
export PATH="$MYDOTFILES/build/nvim/bin:$PATH"
export PATH="$MYDOTFILES/build/vim/bin:$PATH"

export FPATH="$MYDOTFILES/zsh/completions:$FPATH"

# Custom Completions
# Completion should be before compinit
if [ ! -d $MYDOTFILES/zsh/completions ]; then
    mkdir -p $MYDOTFILES/zsh/completions/
fi

# gitlab cli completion
if type lab > /dev/null 2>&1 && [ ! -f $MYDOTFILES/zsh/completions/_lab ]; then
    lab completion zsh > $MYDOTFILES/zsh/completions/_lab
fi
# github cli completion
if type hub > /dev/null 2>&1 && [ ! -f $MYDOTFILES/zsh/completions/_hub ]; then
    curl -L https://raw.githubusercontent.com/github/hub/master/etc/hub.zsh_completion -o $MYDOTFILES/zsh/completions/_hub
fi

# ZSH PLUGIN CONFIG
export ZSH_COMPDUMP=$HOME/.zcompdump
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4"
export ZSH_HIGHLIGHT_MAXLENGTH=300
# export ZSH_TMUX_AUTOSTART=true
export KUBE_PS1_SYMBOL_DEFAULT='K8s'
export KUBE_PS1_PREFIX='['
export KUBE_PS1_SUFFIX=']'

_zshrc_get_fzf_default_opts() {
    if type highlight > /dev/null 2>&1; then
        HIGHLIGHT_SIZE_MAX=262143  # 256KiB
        local hloptions="--replace-tabs=8 --style=molokai ${HIGHLIGHT_OPTIONS:-}"
        local previewcmd="highlight --out-format="xterm256" --force "${hloptions}" {} "
    elif type pygmentize > /dev/null 2>&1; then
        local previewcmd="pygmentize -O style=monokai -f console256 -g {}"
    else
        local previewcmd="cat {}"
    fi
    # local fzf_color="--color fg:-1,bg:-1,hl:1,fg+:-1,bg+:-1,hl+:1,info:3,prompt:2,spinner:5,pointer:4,marker:5"
    echo "--height 50% --reverse --preview \""$previewcmd"\" --preview-window=right:50%:hidden --bind=?:toggle-preview"
}
export FZF_DEFAULT_OPTS=$(_zshrc_get_fzf_default_opts)

# Should be called before source ohmyzshrc for faster boot
_zshrc_custom_tmux(){
    if [[ $# -eq 0 ]]; then
        # title "$USER@$HOST"
        # export DISABLE_AUTO_TITLE=true
        local _lst_ses=$(\tmux list-sessions)
        local _exist_sessions=
        local _attached_sessions=
        local _detached_sessions=
        if [[ ! -z $_lst_ses ]]; then
            _exist_sessions=$(echo $_lst_ses | sed "s/:.*//")
            _attached_sessions=$(echo $_lst_ses | grep attached | sed "s/:.*//")
            _detached_sessions=$(echo $_lst_ses | grep -v attached | sed "s/:.*//")
        fi

        if [[ $_exist_sessions = $_attached_sessions ]]; then
            local idx=0
            if [[ ! -z $_exist_sessions ]];then
                echo $_exist_sessions |
                    while read line; do
                        if [[ $idx -eq $line ]]; then
                            (( idx++ ))
                        else
                            break
                        fi
                    done
            fi
            \tmux -u new-session -s $idx
        else
            echo $(echo $_detached_sessions | head -n 1)
            \tmux -u attach -t $(echo $_detached_sessions | head -n 1)
        fi
        # export DISABLE_AUTO_TITLE=
    else
        \tmux $*
    fi
}
if [[ ! $TERM = "linux" ]]; then
    if [[ $TERM = "xterm" || $TERM = "xterm-kitty" ]]; then
        export TERM=xterm-256color
    fi
    if [[ $VIM_TERMINAL = "" && $TMUX = "" && $TERM_PROGRAM != "vscode" && "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]]; then
        _zshrc_custom_tmux
    fi
    if [[ "${VIM_EDITERM_SETUP}" != "" ]]; then
        source "${VIM_EDITERM_SETUP}"
    fi
    alias tmux=_zshrc_custom_tmux
fi


if [ $(uname) = "Darwin" ]; then
    alias excel='open -n /Applications/Microsoft\ Excel.app'
fi

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

# source oh-my-zsh config
source $MYDOTFILES/zsh/ohmyzshrc.zsh

# Removing duplicates in $PATH
remove_dups_in_path() {
    _path=""
    for _p in $(echo $PATH | tr ":" " "); do
        case ":${_path}:" in
            *:"${_p}":* )
                ;;
            * )
                if [ "$_path" ]; then
                    _path="$_path:$_p"
                else
                    _path=$_p
                fi
                ;;
        esac
    done
    export PATH=$_path
    unset _p
    unset _path
}
remove_dups_in_path

# 'cdhi' command
# source $MYDOTFILES/shell/cd_history_bookmark.sh

##### Functions ##### {{{
# Built in
# chpwd() {
#     _cd_history_bookmark_save_cd_history
# }

# Custom
# maila(){
#     \tmux source $HOME/dotfiles/tmux/mutt_tile
# }
# mailb(){
#     \tmux source $HOME/dotfiles/tmux/mutt_tile2
# }

urlencode(){
  echo "$1" | nkf -WwMQ | tr = %
}

# FZF
fadd() {
    local out q n tgt_files
    while out=$(git status --short | awk '{if (substr($0,2,1) !~ / /) print $2}' | fzf --multi --exit-0 --expect=ctrl-d --expect=ctrl-p); do
        q=$(head -1 <<< "$out")
        n=$[$(wc -l <<< "$out") - 1]
        tgt_files=(`echo $(tail "-$n" <<< "$out")`)
        [[ -z "$tgt_files" ]] && continue
        if [ "$q" = ctrl-d ]; then
            git diff --color=always $tgt_files | less -R
        elif [ "$q" = ctrl-p ]; then
            for tgt_file in $tgt_files; do
                git add -p $tgt_file
            done
        else
            git add $tgt_files
        fi
    done
}
alias fad="fadd"

frst() {
    local out q n tgt_files
    while out=$(git status --short | awk '{if (substr($0,2,1) ~ / /) print $2}' | fzf --multi --exit-0 --expect=ctrl-d --expect=ctrl-p); do
        q=$(head -1 <<< "$out")
        n=$[$(wc -l <<< "$out") - 1]
        tgt_files=(`echo $(tail "-$n" <<< "$out")`)
        [[ -z "$tgt_files" ]] && continue
        if [ "$q" = ctrl-d ]; then
            git diff --color=always --staged $tgt_files | less -R
        elif [ "$q" = ctrl-p ]; then
            for tgt_file in $tgt_files; do
                git reset -p HEAD $tgt_file
            done
        else
            git reset HEAD $tgt_files
        fi
    done
}
alias frs="frst"

fghq() {
    local dir
    dir=$(ghq list > /dev/null 2>&1 | fzf --no-multi --preview 'git --git-dir=$(ghq root)/{}/.git log --color=always --oneline --decorate --graph --branches --tags --remotes') && cd $(ghq root)/$dir
}
alias fhq="fghq"

cdproject() {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        cd `pwd`/`git rev-parse --show-cdup`
    fi
    alias cdpr="cdproject"
    alias cdp="cdproject"
}

if type xsel > /dev/null 2>&1; then
    alias pbcopy="xsel -ib"
    alias pbpaste="xsel -ob"
fi

if type pbcopy > /dev/null 2>&1; then
    alias pwdcopy="pwd | pbcopy"
fi

if type pbpaste > /dev/null 2>&1; then
    cdpaste() {
        if [ -d "$(pbpaste)" ]; then
            cd "$(pbpaste)"
        else
            cd "$(dirname "$(pbpaste)")"
        fi
    }
    alias cdpa="cdpaste"
fi

cddir() {
    cd $(dirname "$@")
}
alias cdd="cddir"


xlsxdiff(){
    diff <(xlsxtxt $1) <(xlsxtxt $2)
}

header_appjson() {
    echo 'Content-Type: application/json'
}

##### Functions END ##### }}}

##### Aliases ##### {{{
# GNU Tools on Mac
if type gsed > /dev/null 2>&1; then
    alias sed="gsed"
fi
if type gls > /dev/null 2>&1; then
    alias ls="gls --color"

    alias l="gls --color -lah"
    alias la="gls --color -la"
    alias ll="gls --color -l"
    alias lsa="gls --color -lah"
fi
if type ggrep > /dev/null 2>&1; then
    alias grep="ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
fi

# Excel diff
if type git-xlsx-textconv > /dev/null 2>&1; then
    alias xlsxtxt="git-xlsx-textconv"
fi

# Trash
if type trash-put > /dev/null 2>&1; then
    alias trm="trash-put"
fi

if type colordiff > /dev/null 2>&1; then
    alias diff="colordiff -u"
else
    alias diff="diff -u"
fi

if type $MYDOTFILES/build/vim/bin/vim > /dev/null 2>&1; then
    # alias vim=$MYDOTFILES/build/vim/bin/vim
    export PATH=$MYDOTFILES/build/vim/bin:$PATH
elif type $HOME/build/vim/bin/vim > /dev/null 2>&1; then
    # alias vim=$HOME/build/vim/bin/vim
    export PATH=$HOME/build/vim/bin:$PATH
elif type /usr/local/bin/vim > /dev/null 2>&1;then
    # alias vim=/usr/local/bin/vim
    export PATH=/usr/local/bin:$PATH
fi

if type $MYDOTFILES/build/vim/bin/gvim > /dev/null 2>&1; then
    alias vim=$MYDOTFILES/build/vim/bin/gvim
elif type $HOME/build/vim/bin/gvim > /dev/null 2>&1; then
    alias vim=$HOME/build/vim/bin/gvim
elif type /usr/local/bin/gvim > /dev/null 2>&1;then
    alias gvim=/usr/local/bin/gvim
fi

# Simple vim
alias svim="vim --cmd \"let g:use_plugins=0\""
# alias tgvim="gvim --remote-tab-silent"
# alias tvim="vim --remote-tab-silent"
alias gnvim="nvim-qt"
alias memo="vim -c \"MemoNew\""

if type /usr/local/bin/emacs > /dev/null 2>&1;then
    alias emacs=/usr/local/bin/emacs
fi

alias dir="dir --group-directories-first --color=auto"
if type pygmentize > /dev/null 2>&1; then
    alias pyg="pygmentize -O style=monokai -f 256 -g"
    alias ccat="pyg"
fi

if type highlight > /dev/null 2>&1; then
    alias hlt="highlight -O ansi"
fi

alias ggr="git graph"

autoload -Uz zmv
alias zmv='noglob zmv -W'

alias http-echo='http-echo-server'
alias http-srv='python3 -m http.server 3000'
alias dock='docker'
alias doco='docker-compose'

if type kubectl >/dev/null 2>&1; then
  kubectl () {
    unset -f kubectl
    # lazy load
    source <(kubectl completion ${SHELL##*/})
    kubectl "$@"
  }
fi
alias k='kubectl'

alias cauthget='curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $CURL_AUTH_TOKEN" https://localhost/'
alias cauthpost='curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $CURL_AUTH_TOKEN" https://localhost -d '
alias cauthput='curl -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $CURL_AUTH_TOKEN" https://localhost -d '
alias cauthdelete='curl -X DELETE -H "Content-Type: application/json" -H "Authorization: Bearer $CURL_AUTH_TOKEN" https://localhost/'
alias cget='curl -X GET -H "Content-Type: application/json" https://localhost/'
alias cpost='curl -X POST -H "Content-Type: application/json" https://localhost -d '
alias cput='curl -X PUT -H "Content-Type: application/json" https://localhost -d '
alias cdelete='curl -X DELETE -H "Content-Type: application/json" https://localhost/'

# https://qiita.com/astrsk_hori/items/b42fb0e9784146407d08
my-open-alias() {
    if [ -z "$RBUFFER" ] ; then
        my-open-alias-aux
    else
        zle end-of-line
    fi
}

my-open-alias-aux() {
    str=${LBUFFER%% }
    bp=$str
    str=${str##* }
    bp=${bp%%${str}}
    targets=`alias ${str}`
    if [ $targets ]; then
        cmd=`echo $targets|cut -d"=" -f2`
        LBUFFER=$bp${cmd//\'/}
    fi
}

zle -N my-open-alias
bindkey "^ " my-open-alias
##### Aliases END ##### }}}

##### Configurations ##### {{{
## BIND
[[ $- == *i* ]] && stty -ixon
bindkey \^U backward-kill-line

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=999999
export SAVEHIST=$HISTSIZE

setopt auto_param_slash      # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs             # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt auto_menu             # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys       # カッコの対応などを自動的に補完
setopt interactive_comments  # コマンドラインでも
setopt magic_equal_subst     # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt complete_in_word      # 語の途中でもカーソル位置で補完
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt print_eight_bit       # 日本語ファイル名等8ビットを通す
setopt extended_glob         # 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt globdots              # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt auto_cd               # "./dir"で"cd ./dir"になる


zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:approximate:*' max-errors 3 numeric
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:corrections' format '%F{yellow}%B-- %d -- %F{red}(errors: %e)%b%f'
zstyle ':completion:*:descriptions' format '%F{yellow}%B-- %d --%b%f'
zstyle ':completion:*:messages' format '%F{yellow}-- %d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for:%F{yellow} %d%f'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache true
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
##### Configurations END ##### }}}
#
# Override by local configurations
if [[ -e "$HOME/localrcs/zsh-local.zsh" ]]; then
    source "$HOME/localrcs/zsh-local.zsh"
fi

