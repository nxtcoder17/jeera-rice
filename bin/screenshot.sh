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

dragon-drag-and-drop $name --and-exit
