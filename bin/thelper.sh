#! /usr/bin/env bash

session=$(tmux list-sessions -F '#{session_name}:#{pane_current_path}' | dmenu)

session_name=$(echo $session | awk -F: '{print $1}')
dir=$(echo $session | awk -F: '{print $2}')

echo $session_name $dir

cmd="tmux attach -t $session_name-helper -c $dir || tmux new-session -s $session_name-helper -c $dir"

# tmux new session -s $session_name-helper
echo "tmux attach -t $session_name-helper -c $dir || tmux new-session -s $session_name-helper -c $dir" | xclip -selection clipboard

kitty --title nxthelper -e zsh -c "$cmd"
