#! /usr/bin/env bash

### use this script in kitty like this
# map ctrl+shift+s launch --type=overlay --allow-remote-control <path-to-this-script>
###

if [ "$(uname)" = "Darwin" ]; then
  PATH="/opt/homebrew/bin:$PATH"
fi

dir="${XDG_DATA_HOME:-$HOME/.local/share}/kitty/sessions"
mkdir -p "$dir"

[ -e "$HOME/.config/fzf/themes/theme.bash" ] && source "$HOME/.config/fzf/themes/theme.bash"

pushd "$dir" >/dev/null || exit
session_name=$(fzf --reverse --prompt="Create/Save Session: " --print-query <<<"$(ls .)" | tail -1)

[ -z "$session_name" ] && exit 0
popd >/dev/null || exit

kitty @action save_as_session --match "session:." --use-foreground-process=yes --base-dir "$dir" "$session_name"
