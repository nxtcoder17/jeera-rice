#! /usr/bin/env bash

# IDEA_DIR=$HOME/.local/share/idea
# CMD="systemd-run --user --slice=idea.slice $IDEA_DIR/bin/idea.sh"
# N_CMD="$IDEA_DIR/bin/idea.sh"
# CMD="$HOME/.local/tars.uz/idea/bin/idea.sh"
CMD="$HOME/.local/tars.uz/idea-IU-221.5921.22/bin/idea.sh"

[ -f $CMD ] || (echo "executable CMD ($CMD) does not exist" && exit 1)

nohup "$CMD" "$@" &> /dev/null &
