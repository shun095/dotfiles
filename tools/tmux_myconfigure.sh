#!/bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
set -eu

## CONFIG
SOFTWARE_NAME="tmux"
BRANCH_NAME="3.4"
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
./autogen.sh
./configure --prefix=$_PREFIX \
	--enable-utf8proc
make -j${_NUM_PARALLEL} install
