#! /usr/bin/env bash

if [ "$(uname)" = "Darwin" ]; then
  PATH="/opt/homebrew/bin:$PATH"
fi

selected=$(kitty @ ls | jq '.[].tabs[].title' | fzf --reverse --prompt "Choose Tab> ")

if [ -z "$selected" ]; then
  exit 0
fi

kitty @ focus-tab --match
