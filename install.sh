#! /usr/bin/env bash

dir=$(realpath $(dirname $0))

Zsh() {
	d=$XDG_CONFIG_HOME/zsh
	bkpD="$d.bkp"
	if ! [ -d $bkpD ]; then
		[ -d $d ] && echo "$d already exists, backing it up" && mv "$d" "$bkpD"
		ln -s $dir/config/zsh $d
	fi
}

Nvim() {
	d=$XDG_CONFIG_HOME/nvim
	bkpD="$d.bkp"
	if ! [ -d $bkpD ]; then
		[ -d $d ] && echo "$d already exists, backing it up" && mv "$d" "$bkpD"
		ln -s $dir/config/nvim $d
	fi
}

Zsh
Nvim
