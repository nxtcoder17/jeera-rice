#!/usr/bin/env bash
set -euo pipefail

dir="${XDG_DATA_HOME:-$HOME/.local/share}/kitty/sessions"
mkdir -p "$dir"

[ -e "$HOME/.config/fzf/themes/theme.bash" ] && source "$HOME/.config/fzf/themes/theme.bash"

session_name=$(fzf --reverse --prompt="Create/Save Session: " --print-query <<<"$(ls $dir)" | tail -1 || exit 0)
[ -z "$session_name" ] && exit 0
# kitty @ action save_as_session --save-only --use-foreground-process --match=session:. "$target"
kitty @action save_as_session --save-only --match=session:. --use-foreground-process=yes --base-dir "$dir" "$session_name"
notify-send "saved kitty session: $session_name"
