#!/bin/sh


# ${0} の dirname を取得
cwd=`dirname "${0}"`

# ${0} が 相対パスの場合は cd して pwd を取得
expr "${0}" : "/.*" > /dev/null || cwd=`(cd "${cwd}" && pwd)`

PREFIX=${cwd}/Build

cd ${cwd}/vim
./configure --prefix=${PREFIX} \
	--with-features=huge \
	--enable-fail-if-missing \
	--enable-gui=gnome2 \
	--enable-luainterp=dynamic \
	--with-luajit \
	--enable-perlinterp=dynamic \
	--enable-python3interp=dynamic \
	--enable-pythoninterp=dynamic \
	--enable-rubyinterp=dynamic

echo 
echo This program will be installed in ${PREFIX}
echo 
