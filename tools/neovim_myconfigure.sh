#!/bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
set -eu

##### NEOVIM #####
## CONFIG
SOFTWARE_NAME="neovim"
BRANCH_NAME="v0.11.3"
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
make -j${_NUM_PARALLEL} CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${_PREFIX} -DCMAKE_BUILD_TYPE=RelWithDebInfo"
make install

# ##### NEOVIM-QT #####
# ## CONFIG
# SOFTWARE_NAME="neovim-qt"
# BRANCH_NAME="v0.2.19"
# NEEDS_PULL=true

# ## COMMON
# . ./myconfigure_setup.sh
# _SCRIPT_DIR=$(cd $(dirname $0);pwd)
# _NUM_PARALLEL=$(get_num_cpus)
# _PREFIX=$(get_prefix $SOFTWARE_NAME)
# _REPO_DIR=${_SCRIPT_DIR}/${SOFTWARE_NAME}
# update_repository "${_REPO_DIR}" "${BRANCH_NAME}" "${NEEDS_PULL}"

# SCRIPT_DIR=$(cd $(dirname $0);pwd)

# make -j${_NUM_PARALLEL} CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${_PREFIX} -DCMAKE_BUILD_TYPE=Release"
# make install
