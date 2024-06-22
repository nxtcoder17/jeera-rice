#! /usr/bin/env bash

dir=${1:-$PWD}

script_bin=$0

if [ -d "$dir/.git" ]; then
	echo "$dir"
	# exit 0
else
	$script_bin $(dirname $dir)
fi
