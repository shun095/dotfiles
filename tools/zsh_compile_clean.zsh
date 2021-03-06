#!/usr/bin/env zsh
#
# zsh_compile.sh
# Copyright (C) 2018 ishitaku5522
#
# Distributed under terms of the MIT license.

set -eu

pushd $HOME/.oh-my-zsh/ &&
    echo "$(pwd): Removing zwc file" &&
    for f in $(find . -name "*.zwc"); do \rm -f $f;  done &&
        popd

pushd $HOME/.fzf/ &&
    echo "$(pwd): Removing zwc file" &&
    for f in $(find . -name "*.zwc"); do \rm -f $f;  done &&
        popd

pushd $HOME/dotfiles/ &&
    echo "$(pwd): Removing zwc file" &&
    for f in $(find . -name "*.zwc"); do \rm -f $f; done &&
        popd

pushd $HOME/.oh-my-zsh/custom/plugins/zsh-completions/src/ &&
    echo "$(pwd): Removing zwc file" &&
    for f in $(find . -name "*.zwc"); do \rm -f $f;  done &&
        popd

pushd $HOME &&
    echo "$(pwd): Creating zwc file" &&
    zcompile ~/.zshenv &&
    zcompile ~/.zshrc &&
    popd
