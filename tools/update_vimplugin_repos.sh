#!/bin/bash - 

set -eu

plugdir="$HOME/.vim/plugged/"


update_plugin() {
    local authername=$1
    local plugname=$2
    pushd ${plugdir}/${plugname}
        git remote set-url origin https://ishitaku5522@github.com/ishitaku5522/${plugname}
        git fetch --unshallow || true
        git pull https://github.com/${authername}/${plugname} master
        git push
    popd
}


update_plugin "prabirshrestha" "asyncomplete.vim"
update_plugin "prabirshrestha" "vim-lsp"
update_plugin "yami-beta" "asyncomplete-omni.vim"
update_plugin "Xuyuanp" "nerdtree-git-plugin"
