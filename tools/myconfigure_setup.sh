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
	echo $MYDOTFILES/build/${sw_name}
}

update_repository() {
	local repo_dir=$1
	local branch_name=$2
	local needs_pull=$3
	cd ${repo_dir}
	git fetch origin ${branch_name}
	git fetch -t --force
	git checkout ${branch_name}

	if ${needs_pull}; then
		git reset --hard origin/${branch_name} | true
	fi
}
