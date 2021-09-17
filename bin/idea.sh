#! /usr/bin/env bash

IDEA_DIR=$HOME/apps/x-bin/idea
CMD="systemd-run --user --slice=idea.slice $IDEA_DIR/bin/idea.sh"
N_CMD="$IDEA_DIR/bin/idea.sh"

nohup "$N_CMD" "$*" &> /dev/null &
