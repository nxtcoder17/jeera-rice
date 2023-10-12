#! /usr/bin/env bash

name=""

if [ -z "$1" ]; then
	name="/tmp/screenshot-$RANDOM".png
else
	dir="$HOME/pictures/screenshots"
	mkdir -p $dir
	name="$dir/$1"
fi

scrot -s $name
[ -f "$name" ] && dragon -x "$name" >/dev/null 2>&1

