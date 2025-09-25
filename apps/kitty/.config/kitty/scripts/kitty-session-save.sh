#! /usr/bin/env bash

dir="${XDG_DATA_HOME:-$HOME/.local/share}/kitty/sessions"
mkdir -p "$dir"

pushd "$dir" >/dev/null || exit
session_name=$(fzf --reverse --prompt="Create/Save Session: " --print-query <<<"$(ls .)" | tail -1)

[ -z "$session_name" ] && exit 0
popd >/dev/null || exit

kitty @action save_as_session --save-only --match='session:.' --use-foreground-process --relocatable "$dir/$session_name"
