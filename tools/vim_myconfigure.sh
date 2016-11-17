#!/bin/sh
set -eu

# ${0} の dirname を取得
cwd=`dirname "${0}"`
# ${0} が 相対パスの場合は cd して pwd を取得
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`

PREFIX=${cwd}/Build

cd ${cwd}/vim
git pull origin master
git checkout master
./configure --prefix=${PREFIX} \
    --enable-fail-if-missing \
    --enable-gui=gnome2 \
    --enable-luainterp=dynamic \
    --enable-perlinterp=dynamic \
    --enable-python3interp=dynamic \
    --enable-pythoninterp=dynamic \
    --enable-rubyinterp=dynamic \
    --with-features=huge \
    --with-luajit

echo 
echo "This program will be installed in ${PREFIX}.""
echo "Install now???[y/n]""
read ans

case $ans in
    [Yy] | [Yy][Ee][Ss] )
        make -j install
        ;;
    * )
        echo "Terminated.";;
esac
