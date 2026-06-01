#! /usr/bin/env bash

# CMD="systemd-run --user --slice=idea.slice $IDEA_DIR/bin/idea.sh"
CMD="$HOME/.local/tars.uz/idea/bin/idea"

[ -f $CMD ] || (echo "executable CMD ($CMD) does not exist" && exit 1)

# systemd-run --slice=intellij.slice -- nohup "$CMD" "$@" &> /dev/null &
# nohup "$CMD" "$@" &> /dev/null &
# cpulimit -l 550 nohup "$CMD" "$@" &> /dev/null &
# echo executing $CMD
# $CMD
nohup "$CMD" "$@" &>/dev/null &
