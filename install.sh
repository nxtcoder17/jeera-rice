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

InstallTelepresence() {
  curl -fL https://app.getambassador.io/download/tel2/linux/amd64/latest/telepresence -o $HOME/apps/x-bin/telepresence
  ln -sf $HOME/apps/x-bin/telepresence $HOME/apps/jeera-rice/bin/telepresence
}

# i3 

Zsh
Nvim
