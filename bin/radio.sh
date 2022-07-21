#! /usr/bin/env bash

swd=$(realpath $(dirname $0))

listFile=$1
if [ -n $listFile ]; then
  listFile="$swd/../radio-list.txt"
fi

[ -f $listFile ] || (echo "radio list listFile not found" && exit 1)
# echo $listFile
# cat $listFile

item=$(cat $listFile | fzf --with-nth=1)
# echo "item: $item"

if [ -n "$item" ]; then
  name=$(echo "$item" | awk '{print $1}')
  url=$(echo "$item" | awk '{print $2}')
  echo "[PLAYING] $name"
  mpv $url
fi
