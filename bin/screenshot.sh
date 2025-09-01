#! /usr/bin/env bash

if [[ "$XDG_BACKEND" = "wayland" ]]; then
  hyprshot -m region --clipboard-only
  return
fi

# for xorg

name="/tmp/screenshot-$RANDOM".png

# name=""

# if [ -z "$1" ]; then
# name="/tmp/screenshot-$RANDOM".png
# else
#   dir="$HOME/pictures/screenshots"
#   mkdir -p $dir
#   name="$dir/$1"
# fi

scrot -s $name
dragon-drop -x "$name" >/dev/null 2>&1
