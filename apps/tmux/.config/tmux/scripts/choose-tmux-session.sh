#! /usr/bin/env bash

# echo "$FZF_DEFAULT_OPTS"

tmux list-sessions -F '#S' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse --prompt 'choose session ❭❭ ' | xargs -r tmux switch-client -t
