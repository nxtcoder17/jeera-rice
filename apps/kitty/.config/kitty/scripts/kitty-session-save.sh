#! /usr/bin/env bash

### use this script in kitty like this
# map ctrl+shift+s launch --type=tab --allow-remote-control <path-to-this-script>
###

dir="${XDG_DATA_HOME:-$HOME/.local/share}/kitty/sessions"
mkdir -p "$dir"

pushd "$dir" >/dev/null || exit
session_name=$(fzf --reverse --prompt="Create/Save Session: " --print-query <<<"$(ls .)" | tail -1)

[ -z "$session_name" ] && exit 0
popd >/dev/null || exit

temp=$(mktemp)
kitty @action save_as_session --match='session:.' --save-only --use-foreground-process "$temp"

# ignores last 2 paragraphs that are created because of this script being opened in a new tab
# cat "$temp" >"$dir/$session_name"
awk -v RS= 'NR>2 {print buf[NR-2] RS "\n" } {buf[NR]=$0}' "$temp" >"$dir/$session_name"
rm "$temp"
# kitty @action close_tab
