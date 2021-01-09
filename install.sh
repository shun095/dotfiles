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
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/ishitaku5522/dotfiles/master/install-invoke.sh)"; \
fi

