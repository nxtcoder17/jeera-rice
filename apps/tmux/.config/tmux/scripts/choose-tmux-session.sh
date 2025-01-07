#! /usr/bin/env bash

# tmux list-sessions -F '#S' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse --prompt 'choose session ❭❭ ' | xargs -r tmux switch-client -t
# echo "$FZF_DEFAULT_OPTS"

current_session=$(tmux display-message -p '#S')
items=$(tmux list-sessions -F '#S' | grep -v "$current_session")

# items+="\n$(tmux display-message -p '#{pane_id}')"

# tmux list-sessions -F '#S' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse --prompt 'choose session ❭❭ ' | xargs -r tmux switch-client -t
echo "$items" | fzf --reverse --prompt 'choose session ❭❭ ' | xargs -r tmux switch-client -t
