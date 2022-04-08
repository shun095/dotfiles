#!/usr/bin/env bash

set -eu

MYDOTFILES=$HOME/dotfiles

if [ -d "${MYDOTFILES}/.git" ];then
	pushd ${MYDOTFILES}
		echo "Updating dotfiles"
		git pull
	popd
	${MYDOTFILES}/install-invoke.sh $@
else
	git clone https://github.com/shun095/dotfiles.git ${MYDOTFILES}
	${MYDOTFILES}/install.sh
fi

