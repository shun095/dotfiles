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

export GOPATH=$HOME/.gopath
export PATH="$HOME/build/go/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

export PATH="$HOME/build/node/bin:$PATH"
export PATH="$HOME/.nodebrew/current/bin:$PATH"

export PATH="$HOME/build/emacs/bin:$PATH"
export PATH="$HOME/build/tig/bin:$PATH"
export PATH="$HOME/build/tmux/bin:$PATH"
export PATH="$HOME/build/ctags/bin:$PATH"
export PATH="$HOME/build/nvim-qt/bin:$PATH"
export PATH="$HOME/build/nvim/bin:$PATH"
export PATH="$HOME/build/vim/bin:$PATH"

export USE_CCACHE=1

# GENERAL
export MYDOTFILES=$HOME/dotfiles

# ZSH PLUGIN CONFIG
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=4"
export ZSH_HIGHLIGHT_MAXLENGTH=300

_zshrc_get_fzf_default_opts() {
    if command -v highlight > /dev/null; then
        HIGHLIGHT_SIZE_MAX=262143  # 256KiB
        local hloptions="--replace-tabs=8 --style=molokai ${HIGHLIGHT_OPTIONS:-}"
        local previewcmd="highlight --out-format="xterm256" --force "${hloptions}" {} "
    elif command -v pygmentize > /dev/null; then
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
    if [[ $TERM = "xterm" ]]; then
        export TERM=xterm-256color
    fi
    if [[ $VIM_TERMINAL = "" && $TMUX = "" ]]; then
        _zshrc_custom_tmux
    fi
    if [[ "${VIM_EDITERM_SETUP}" != "" ]]; then
        source "${VIM_EDITERM_SETUP}"
    fi
    alias tmux=_zshrc_custom_tmux
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
source $MYDOTFILES/zsh/cd_history_bookmark.zsh

##### Functions ##### {{{
# Built in
chpwd() {
    _cd_history_bookmark_save_cd_history
}

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
    dir=$(ghq list > /dev/null | fzf --no-multi) && cd $(ghq root)/$dir
}
alias fhq="fghq"

cdproject() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    cd `pwd`/`git rev-parse --show-cdup`
  fi
}

if command -v pbpaste > /dev/null; then
    cdpaste() {
        if [ -d $(pbpaste) ]; then
            cd $(pbpaste)
        else
            cd $(dirname $(pbpaste))
        fi
    }
fi

cddir() {
    cd $(dirname "$1")
}

if command -v kubectl > /dev/null; then
  kubectl() {
    # Remove this function, subsequent calls will execute 'kubectl' directly
    unfunction "$0"
    # Load auto-completion
    source <(kubectl completion zsh)
    complete -o default -F __start_kubectl k
    $0 "$@"
  }
  alias k="kubectl"
fi
##### Functions END ##### }}}

##### Aliases ##### {{{
# GNU Tools on Mac
if command -v gsed > /dev/null; then
    alias sed="gsed"
fi
if command -v gls > /dev/null; then
    alias ls="gls --color"

    alias l="gls --color -lah"
    alias la="gls --color -la"
    alias ll="gls --color -l"
    alias lsa="gls --color -lah"
fi
if command -v ggrep > /dev/null; then
    alias grep="ggrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"
fi

# Excel diff
if command -v git-xlsx-textconv > /dev/null; then
    alias xlsxtxt="git-xlsx-textconv"
fi

# Trash
if command -v trash-put > /dev/null; then
    alias trm="trash-put"
fi

if command -v colordiff > /dev/null; then
    alias diff="colordiff -u"
else
    alias diff="diff -u"
fi

if command -v $HOME/build/vim/bin/vim > /dev/null; then
    :
elif command -v /usr/local/bin/vim > /dev/null;then
    alias vim=/usr/local/bin/vim
fi

if command -v /usr/local/bin/gvim > /dev/null;then
    alias gvim=/usr/local/bin/gvim
fi

# Simple vim
alias svim="vim --cmd \"let g:use_plugins=0\""
alias tgvim="gvim --remote-tab-silent"
alias tvim="vim --remote-tab-silent"
alias gnvim="nvim-qt"

if command -v /usr/local/bin/emacs > /dev/null;then
    alias emacs=/usr/local/bin/emacs
fi

alias dir="dir --group-directories-first --color=auto"
if command -v pygmentize > /dev/null; then
    alias pyg="pygmentize -O style=monokai -f 256 -g"
    alias ccat="pyg"
fi

if command -v highlight > /dev/null; then
    alias hlt="highlight -O ansi"
fi

alias ggr="git graph"

autoload -Uz zmv
alias zmv='noglob zmv -W'
##### Aliases END ##### }}}

##### Configurations ##### {{{
## BIND
stty stop undef
bindkey \^U backward-kill-line

export ZSH_COMPDUMP=$HOME/.zcompdump
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

