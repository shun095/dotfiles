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

function _cd_history_bookmark_filter(){
    sed -e "s?^${PWD}\$??g" | sed 's/#.*//g' | sed '/^\s*$/d' | cat
}

function _cd_history_bookmark_save_cd_history(){
    local file_path="$HOME/.cd_history"
    _cd_history_bookmark_add_path_to_file $file_path
}

function _cd_history_bookmark_fzf(){
    local file_path=$1
    local dest_dir=$(tac $file_path | _cd_history_bookmark_filter | fzf --height 40% --reverse)
    if [[ $dest_dir != '' ]]; then
        cd "$dest_dir"
    fi
}

function _cd_history_bookmark_add_path_to_file(){
    local file_path=$1
    touch $file_path
    sed -i -e "s?^${PWD}\$??g" $file_path
    sed -i -e "/^\s*\$/d" $file_path

    if [[ `cat $file_path | wc -l` -eq 0 ]];then
        echo > $file_path
    fi

    sed -i -e "\$a${PWD}" $file_path
}

function bkmk(){
    local file_path="$HOME/.cd_bookmark"
    _cd_history_bookmark_add_path_to_file $file_path
}

function delbkmk(){
    sed -i -e "s?^${PWD}\$??g" ~/.cd_bookmark 
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

