#!/bin/sh

get_num_cpus() {
	if [ "$(uname)" = 'Darwin'  ]; then
		echo $(sysctl -n hw.logicalcpu_max)
	else
		echo $(grep processor /proc/cpuinfo | wc -l)
	fi
}

get_prefix() {
	local sw_name=$1
	echo $HOME/build/${sw_name}
}

update_repository() {
	local repo_dir=$1
	local branch_name=$2
	local needs_pull=$3
	cd ${repo_dir}
	git fetch -t -f
	git checkout ${branch_name}

	if ${needs_pull}; then
		git pull
	fi
}
