#! /usr/bin/env bash

# DMENU="dmenu"
# [ "$XDG_BACKEND" = "wayland" ] && DMENU="dmenu-wl"

DMENU='rofi -dmenu'

helper_suffix="/helper"

# session=$(tmux list-sessions -F '#{session_name}:#{pane_current_path}' | grep -v "$helper_suffix" | eval $DMENU -p "Session")
session=$(tmux list-sessions -F '#{session_name}:' | grep -v "$helper_suffix" | eval $DMENU -p "Session")
echo "session: $session"
session_name=$(echo $session | awk -F: '{print $1}')
# dir=$(echo $session | awk -F: '{print $2}')

helper_tmux_session="$session_name$helper_suffix"

# cmd="tmux attach -t $helper_tmux_session -c $dir || tmux new-session -s $helper_tmux_session -c $dir"
cmd="tmux attach -t $helper_tmux_session || tmux new-session -s $helper_tmux_session"

kitty --title nxthelper fish -c "$cmd"
