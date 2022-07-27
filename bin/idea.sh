#! /usr/bin/env bash

# CMD="systemd-run --user --slice=idea.slice $IDEA_DIR/bin/idea.sh"
# CMD="$HOME/.local/tars.uz/idea-IU-221.5921.22/bin/idea.sh"
CMD="$HOME/.local/tars.uz/idea-IU-222.3345.118/bin/idea.sh"

[ -f $CMD ] || (echo "executable CMD ($CMD) does not exist" && exit 1)

nohup "$CMD" "$@" &> /dev/null &
