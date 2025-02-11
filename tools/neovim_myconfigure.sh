#!/bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
set -eu

SCRIPT_DIR=$(cd $(dirname $0);pwd)

NVIM_PREFIX=$HOME/build/nvim
NVIMQT_PREFIX=$HOME/build/nvim-qt
CPUNUM=`cat /proc/cpuinfo | grep -c processor`

cd ${SCRIPT_DIR}/neovim
git checkout master
git pull

make -j${CPUNUM} CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${NVIM_PREFIX} -DCMAKE_BUILD_TYPE=Release"
make install

cd ${SCRIPT_DIR}/neovim-qt/build
git checkout master
git pull

cmake -DCMAKE_INSTALL_PREFIX=${NVIMQT_PREFIX} -DCMAKE_BUILD_TYPE=Release ..
make -j${CPUNUM}
make install
