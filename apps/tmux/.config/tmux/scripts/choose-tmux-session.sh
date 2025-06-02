#!/usr/bin/env bash

current_session=$(tmux display-message -p '#S')
items=$(tmux list-sessions -F '#S' | grep -v "$current_session\$")

echo "$items" | fzf --reverse --prompt 'choose session ❭❭ ' | xargs -r tmux switch-client -t
