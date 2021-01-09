#!/usr/bin/env bash

set -eu

MYDOTFILES=$HOME/dotfiles

if [ -d ${MYDOTFILES} ];then
	pushd ${MYDOTFILES}
		git pull
	popd
fi

${MYDOTFILES}/install-invoke.sh $@
