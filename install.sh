#!/usr/bin/env bash
# vim: sw=4 sts=4 et :

set -eu

MYDOTFILES=$HOME/dotfiles

if [ -d "${MYDOTFILES}/.git" ];then
    ${MYDOTFILES}/install-invoke.sh $@
else
    git clone https://github.com/shun095/dotfiles.git ${MYDOTFILES}
    ${MYDOTFILES}/install.sh
fi

