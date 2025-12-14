#! /usr/bin/env bash

if [[ "$XDG_BACKEND" = "wayland" ]]; then
  t=$(mktemp)
  hyprshot -m region -o /tmp --filename $(basename $t)
  echo "$t" | wl-copy
  exit 0
fi

# for X11
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
