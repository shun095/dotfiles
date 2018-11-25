#!/usr/bin/env zsh

export EDITOR=vim
export MYDOTFILES=$HOME/dotfiles
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=59"

export GOPATH=$HOME/.gopath

export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/usr/bin:$PATH"
export PATH="$HOME/.go/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/build/tmux/bin:$PATH"
export PATH="$HOME/build/emacs/bin:$PATH"
export PATH="$HOME/build/ctags/bin:$PATH"
export PATH="$HOME/build/nvim-qt/bin:$PATH"
export PATH="$HOME/build/nvim/bin:$PATH"
export PATH="$HOME/build/vim/bin:$PATH"

if type pyenv > /dev/null; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

source $MYDOTFILES/zsh/ohmyzshrc.zsh
source $MYDOTFILES/zsh/cd_history_bookmark.zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'
export FZF_DEFAULT_OPTS='--color=16'

setopt auto_cd

function chpwd() {
    _cd_history_bookmark_save_cd_history
    # ls --color=auto
}

function maila(){
    \tmux source ~/dotfiles/tmux/mutt_tile
}
function mailb(){
    \tmux source ~/dotfiles/tmux/mutt_tile2
}

function tmux_call(){
    if [[ $# -eq 0 ]]; then
        if [[ `\tmux list-sessions 2>/dev/null|wc -l` -ne 0 ]]; then
            exist_sessions=(`\tmux list-sessions|sed "s/:.*//"`)
            attached_sessions=(`\tmux list-sessions|grep attached|sed "s/:.*//"`)
            detached_sessions=(`\tmux list-sessions|grep -v attached|sed "s/:.*//"`)
        fi

        if [[ $#exist_sessions -eq $#attached_sessions ]]; then
            idx=0
            while [[ -n ${exist_sessions[(re)$idx]} ]]; do
                (( idx++ ))
            done
            \tmux new-session -s $idx
        else
            \tmux attach -t ${detached_sessions[1]}
        fi
    else
        \tmux $*
    fi
}

if type trash-put > /dev/null; then
    alias rm="trash-put"
else
    echo "Recommended to install 'trash-cli'"
    to_trash() {
        for file in $@
        do
            mv $file ~/.trash
        done
    }
    alias rm="to_trash"
fi

if [[ -e "$HOME/localrcs/zsh-local.zsh" ]]; then
    source "$HOME/localrcs/zsh-local.zsh"
fi

if type colordiff > /dev/null; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

gvim_call(){
    if [[ `\gvim --serverlist 2>/dev/null|wc -l` -ne 0 ]]; then
        \gvim --remote $*
    else
        \gvim $*
    fi

}

if [[ ! $TERM = 'linux' ]]; then
    tmux_call
    alias tmux=tmux_call
fi

if type /usr/local/bin/vim > /dev/null;then
    alias vim=/usr/local/bin/vim
fi
if type /usr/local/bin/gvim > /dev/null;then
    alias gvim=/usr/local/bin/gvim
fi
if type /usr/local/bin/emacs > /dev/null;then
    alias emacs=/usr/local/bin/emacs
fi

alias tgvim="gvim --remote-tab-silent"
alias tvim="vim --remote-tab-silent"
alias gnvim="nvim-qt"

alias dir="dir --group-directories-first --color=auto"
alias pyg="pygmentize"
stty stop undef

bindkey \^U backward-kill-line

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

zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
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


# Removing duplicates in $PATH
_path=""
for _p in $(echo $PATH | tr ':' ' '); do
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
