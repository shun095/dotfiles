#! /bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
if [ ! -d tmux ]; then
    git clone https://github.com/tmux/tmux.git
fi
CPUNUM=`cat /proc/cpuinfo | grep -c processor`
cd tmux
git checkout 2.4
sh autogen.sh
./configure --prefix=$HOME/usr/
make -j${CPUNUM} 
make install
