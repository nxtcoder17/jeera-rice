#! /usr/bin/env bash

# CMD="systemd-run --user --slice=idea.slice $IDEA_DIR/bin/idea.sh"
CMD="$HOME/.local/tars.uz/idea-IU-231.9011.34/bin/idea.sh"

[ -f $CMD ] || (echo "executable CMD ($CMD) does not exist" && exit 1)

# systemd-run --slice=intellij.slice -- nohup "$CMD" "$@" &> /dev/null &
# nohup "$CMD" "$@" &> /dev/null &
cpulimit -l 550 nohup "$CMD" "$@" &> /dev/null &
