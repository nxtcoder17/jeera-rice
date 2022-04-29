#! /usr/bin/env bash

# IDEA_DIR=$HOME/.local/share/idea
# CMD="systemd-run --user --slice=idea.slice $IDEA_DIR/bin/idea.sh"
# N_CMD="$IDEA_DIR/bin/idea.sh"
CMD="$HOME/.local/bin/idea-run-script.sh"
# echo 'nohup "$CMD" "$@" &> /dev/null'
nohup "$CMD" "$@" &> /dev/null &
