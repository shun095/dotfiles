#!/usr/bin/env zsh

# cd_history_bookmark
# Copyright (C) 2017 ishitaku5522 <ishitaku5522@gmail.com>
#
# Distributed under terms of the MIT license.

# 1. You have to install fzf to use this script.
#    https://github.com/junegunn/fzf
# 
# 2. Please write _cd_history_bookmark_save_cd_history in your chpwd() function.
#    ~/.zshrc:
#    function chpwd() {
#       _cd_history_bookmark_save_cd_history
#       ls
#    }
# 
# 3. You can use book mark and cd history.
#    commands:
#    cdhi -> cd using your history
#    cdbk -> cd usign your bookmarks
#    bkmk -> bookmark current directory
#    delbkmk -> delete current direcotry from bookmark list

_cd_history_bookmark_limit=100

if sed --version 2>/dev/null | grep -q GNU; then
    _cd_history_bookmark_sedi="sed -i -e"
    tac="tac"
else
    _cd_history_bookmark_sedi="sed -i .bak -e"
    tac="tail -r"
fi

function _cd_history_bookmark_filter(){
    sed -e "s?^${PWD}\$??g" | sed 's/#.*//g' | sed '/^\s*$/d' | cat
}

function _cd_history_bookmark_save_cd_history(){
    local file_path="$HOME/.cd_history"
    _cd_history_bookmark_add_path_to_file $file_path
}

function _cd_history_bookmark_fzf(){
    local file_path=$1
    local dest_dir=$(eval $tac' '$file_path | _cd_history_bookmark_filter | fzf --no-sort --height 40% --reverse --preview-window=hidden)
    if [[ $dest_dir != '' ]]; then
        if ! cd "$dest_dir"; then
            eval $_cd_history_bookmark_sedi' "s?^${dest_dir}\(\$\|/.*\$\)??g" '${file_path} &&
            eval $_cd_history_bookmark_sedi' "/^\s*\$/d" '$file_path # Delete empty lines
        fi

    fi
}

function _cd_history_bookmark_add_path_to_file(){
    local file_path=$1
    touch $file_path # Create the file if not exists
    eval $_cd_history_bookmark_sedi' "s?^${PWD}\$??g" '$file_path # Delete same directory lines
    eval $_cd_history_bookmark_sedi' "/^\s*\$/d" '$file_path # Delete empty lines

    if [[ $(cat $file_path | wc -l) -eq 0 ]]; then
        echo > $file_path # Create a empty line if the file size is zero
    elif [[ $(cat $file_path | wc -l) -gt ${_cd_history_bookmark_limit} ]]; then # Limit history size
        tail -n ${_cd_history_bookmark_limit} $file_path > $HOME/cd_hist_tmp.txt
        mv $HOME/cd_hist_tmp.txt $file_path
    fi

    echo "\n" >> $file_path
    eval $_cd_history_bookmark_sedi' "\$s?^?${PWD}?" '$file_path # Add the path to the file
}

function bkmk(){
    local file_path="$HOME/.cd_bookmark"
    _cd_history_bookmark_add_path_to_file $file_path
}

function delbkmk(){
    eval $_cd_history_bookmark_sedi' "s?^${PWD}\$??g" ''~/.cd_bookmark'
}

function cdbk() {
    local file_path="$HOME/.cd_bookmark"
    if [[ ! -e $file_path ]];then
        echo "No bookmarks exist."
        return
    fi

    _cd_history_bookmark_fzf $file_path
}

function cdhi() {
    local file_path="$HOME/.cd_history"

    if [[ ! -e $file_path ]];then
        return
    fi

    _cd_history_bookmark_fzf $file_path
}

