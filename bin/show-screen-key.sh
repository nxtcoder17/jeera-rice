#! /usr/bin/env bash

pid=$(pgrep screenkey)
if ! [ -z "$pid" ]; then
  kill $pid
  exit 0
fi

screenkey -p fixed -g 60%x10%-5%-10% --font-size small --key-mode translated --font 'ComicCodeLigautres Nerd Font 5'

