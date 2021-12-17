#!/bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
set -eu

## CONFIG
SOFTWARE_NAME="vim"
BRANCH_NAME="master"
NEEDS_PULL=true

## COMMON
. ./myconfigure_setup.sh
_SCRIPT_DIR=$(cd $(dirname $0);pwd)
_NUM_PARALLEL=$(get_num_cpus)
_PREFIX=$(get_prefix $SOFTWARE_NAME)
_REPO_DIR=${_SCRIPT_DIR}/${SOFTWARE_NAME}
update_repository "${_REPO_DIR}" "${BRANCH_NAME}" "${NEEDS_PULL}"

## BUILD
cd $_REPO_DIR
make distclean
if [ "$(uname)" = 'Darwin'  ]; then
	./configure --prefix=${_PREFIX} \
		--with-features=huge \
		--enable-fail-if-missing \
		--enable-fontset \
		--enable-multibyte \
		--enable-gui=auto \
		--with-lua-prefix=/usr/local/ \
		--enable-luainterp=dynamic \
		--with-luajit \
		--enable-python3interp=yes \
		--with-python3-command=python3 \
		--enable-autoservername \
		--enable-rubyinterp=dynamic \
		--enable-terminal
else
	./configure --prefix=${_PREFIX} \
		--with-features=huge \
		--enable-fail-if-missing \
		--enable-fontset \
		--enable-multibyte \
		--enable-gui=auto \
		--enable-luainterp=dynamic \
		--with-luajit \
		--enable-python3interp=dynamic \
		--with-python3-command=python3 \
		--enable-autoservername \
		--enable-rubyinterp=dynamic \
		--enable-terminal
fi

make -j${_NUM_PARALLEL}
make install
