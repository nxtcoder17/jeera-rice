#! /usr/bin/env bash

dir="${XDG_DATA_HOME:-$HOME/.local/share}/kitty/sessions"
mkdir -p "$dir"

pushd "$dir" >/dev/null || exit
session_name=$(fzf --reverse --prompt="Use Session: " <<<"$(ls .)")
[ -n "$session_name" ] || exit 0
popd >/dev/null || exit

kitty @action goto_session "$dir/$session_name"
