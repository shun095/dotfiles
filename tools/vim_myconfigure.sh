#!/bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
set -eu

# ${0} の dirname を取得
cwd=`dirname "${0}"`
# ${0} が 相対パスの場合は cd して pwd を取得
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`

PREFIX=/usr/local
CPUNUM=`cat /proc/cpuinfo | grep -c processor`

cd ${cwd}/vim
git checkout master
git pull origin master
./configure --prefix=${PREFIX} \
    --with-features=huge \
    --enable-fail-if-missing \
    --enable-fontset \
    --enable-multibyte \
    --enable-gui=auto \
    --enable-luainterp=dynamic \
    --with-luajit \
    --enable-perlinterp=dynamic \
    --enable-python3interp=dynamic \
    --enable-pythoninterp=dynamic \
    --enable-rubyinterp=dynamic \
    --enable-terminal

echo 
echo "This program will be installed in ${PREFIX}."
echo "Install now???[y/n]"
read ans

case $ans in
    [Yy] | [Yy][Ee][Ss] )
        make -j${CPUNUM} 
        sudo make install
        # sudo checkinstall --install=no
        ;;
    * )
        echo "Terminated.";;
esac
