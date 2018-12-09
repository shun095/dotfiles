#!/bin/sh
set -eu

SCRIPT_DIR=$(cd $(dirname $0);pwd)

PREFIX=$HOME/build/tmux

CPUNUM=`cat /proc/cpuinfo | grep -c processor`

cd ${SCRIPT_DIR}/tmux
git checkout master
git pull

./autogen.sh
./configure --prefix=$PREFIX
make -j${CPUNUM} 
make install
