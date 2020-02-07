#!/bin/sh
#
# Copyright (C) 2017 ishitaku5522
#
# Distributed under terms of the MIT license.
#
set -eu

## CONFIG
SOFTWARE_NAME="ranger"
BRANCH_NAME="master"
NEEDS_PULL=true

## COMMON
_SCRIPT_DIR=$(cd $(dirname $0);pwd)
if [ "$(uname)" == 'Darwin'  ]; then
	_NUM_PARALLEL=$(sysctl -n hw.logicalcpu_max)
else
	_NUM_PARALLEL=$(grep processor /proc/cpuinfo | wc -l)
fi
_PREFIX=$HOME/build/${SOFTWARE_NAME}

cd ${_SCRIPT_DIR}/${SOFTWARE_NAME}
# git fetch -t
git checkout ${BRANCH_NAME}

if ${NEEDS_PULL}; then
	if git pull | grep "Already up"; then
		exit 0
	fi
fi

## BUILD
target_path=$HOME/usr/bin/ranger
mkdir -p $HOME/usr/bin
if [ -e ${target_path} ];then
	:
else
	ln -s $(pwd)/ranger.py ${target_path}
fi
unset target_path
