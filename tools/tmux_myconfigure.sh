#!/bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
set -eu

SOFTWARE_NAME="tmux"
BRANCH_NAME="2.9a"
NEEDS_PULL=false

_SCRIPT_DIR=$(cd $(dirname $0);pwd)
_NUM_PARALLEL=4
_PREFIX=$HOME/build/${SOFTWARE_NAME}

cd ${_SCRIPT_DIR}/${SOFTWARE_NAME}
git fetch --all -t
git checkout ${BRANCH_NAME}

if ${NEEDS_PULL}; then
    git pull
fi

# Script to build
./autogen.sh
./configure --prefix=$_PREFIX
make -j${_NUM_PARALLEL} install
