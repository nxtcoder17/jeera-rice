#! /usr/bin/env bash

dir="$HOME/Pictures/screenshots"
mkdir -p $dir

if [[ "$XDG_BACKEND" = "wayland" ]]; then
  REGION=$(slurp) || exit
  picture_path="$dir/Screenshot-$(date +%F_%T).png"
  grim -g "$REGION" - | wl-copy && wl-paste >$picture_path && notify-send -a "Screenshot" -i "$picture_path" "Screenshot Taken"
  echo -n "$picture_path" | wl-copy
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
