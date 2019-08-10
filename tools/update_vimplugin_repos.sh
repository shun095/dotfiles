#!/bin/bash - 

set -eu

plugdir="$HOME/.vim/plugged/"


update_plugin() {
    local authername=$(echo $1 | cut -d'/' -f1)
    local plugname=$(echo $1 | cut -d'/' -f2)
    pushd ${plugdir}/${plugname}
        if git remote get-url origin | grep ishitaku5522; then
            git remote set-url origin https://ishitaku5522@github.com/ishitaku5522/${plugname}
            git fetch --unshallow || true
            git pull https://github.com/${authername}/${plugname} master
            git push
            echo "Updated ishitaku5522 version: $1"
        else
            echo "Not a valid repository: $1"
        fi
        echo
    popd
}


update_plugin "prabirshrestha/asyncomplete.vim"
update_plugin "prabirshrestha/asyncomplete-buffer.vim"
update_plugin "prabirshrestha/vim-lsp"
update_plugin "yami-beta/asyncomplete-omni.vim"
update_plugin "Xuyuanp/nerdtree-git-plugin"
