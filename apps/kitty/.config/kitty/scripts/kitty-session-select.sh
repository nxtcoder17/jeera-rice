#! /usr/bin/env bash

dir="${XDG_DATA_HOME:-$HOME/.local/share}/kitty/sessions"
mkdir -p "$dir"

[ -e "$HOME/.config/fzf/themes/theme.bash" ] && source "$HOME/.config/fzf/themes/theme.bash"

pushd "$dir" >/dev/null || exit
session_name=$(fzf --reverse --prompt="Use Session: " <<<"$(ls .)")
[ -n "$session_name" ] || exit 0
popd >/dev/null || exit

kitty @action goto_session "$dir/$session_name"

# INFO: to close the window with title: 'kitty-session-save'
# as kitty also saved the window that triggerd kitty-session-save in the session file, so we need to close this window
kitty @close-window --match title:kitty-session-save

# INFO: to close the tab containing the window with title: 'kitty-session-select'
# as kitty restores session in another tab, so we need to close the tab that has triggered the session restore
kitty @close-tab --match title:kitty-session-select
