#!/bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
set -eu

# ${0} の dirname を取得
SCRIPT_DIR=$(cd $(dirname $0);pwd)

PREFIX=$HOME/build/vim
CPUNUM=`cat /proc/cpuinfo | grep -c processor`

cd ${SCRIPT_DIR}/vim
git checkout master
git pull

./configure --prefix=${PREFIX} \
    --with-features=huge \
    --enable-fail-if-missing \
    --enable-fontset \
    --enable-multibyte \
    --enable-gui=auto \
    --enable-luainterp=dynamic \
    --with-luajit \
    --enable-python3interp=dynamic \
    --with-python3-command=python3.6 \
    --enable-rubyinterp=dynamic \
    --enable-autoservername \
    --enable-terminal
    # --enable-pythoninterp=dynamic \
    # --enable-perlinterp=dynamic \


make -j${CPUNUM} 
make install
# echo 
# echo "This program will be installed in ${PREFIX}."
# echo "Install now???[y/n]"
# read ans

# case $ans in
#     [Yy] | [Yy][Ee][Ss] )
#         sudo make install
#         # sudo checkinstall --install=no
#         ;;
#     * )
#         echo "Terminated.";;
# esac
