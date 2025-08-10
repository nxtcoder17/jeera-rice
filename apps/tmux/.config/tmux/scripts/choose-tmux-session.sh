#!/usr/bin/env bash

current_session=$(tmux display-message -p '#S')
items=$(tmux list-sessions -F '#S' | grep -v "$current_session\$")

source "$HOME/.colorscheme.d/fzf/catppuccin.bash"
echo "$items" | fzf --reverse --prompt 'choose session ❭❭ ' | xargs -r tmux switch-client -t
