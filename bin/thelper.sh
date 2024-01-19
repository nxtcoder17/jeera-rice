#! /usr/bin/env bash

session=$(tmux list-sessions -F '#{session_name}:#{pane_current_path}' | grep -v '-helper' | dmenu)

session_name=$(echo $session | awk -F: '{print $1}')
dir=$(echo $session | awk -F: '{print $2}')

cmd="tmux attach -t $session_name-helper -c $dir || tmux new-session -s $session_name-helper -c $dir"

kitty --title nxthelper fish -c "$cmd"
