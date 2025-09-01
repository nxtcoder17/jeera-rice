#! /usr/bin/env bash

dir="${XDG_DATA_HOME:-$HOME/.local/share}/kitty/sessions"
mkdir -p "$dir"

pushd "$dir" >/dev/null || exit
query=$(fd . | rofi -dmenu -p "Save Kitty Session")
[ -n "$query" ] || exit 0
popd >/dev/null || exit

kitty @action save_as_session --save-only --match='session:.' --use-foreground-process --relocatable "$dir/$query"
