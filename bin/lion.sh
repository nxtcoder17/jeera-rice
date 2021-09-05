#! /usr/bin/env bash

IDEA_DIR=$HOME/apps/x-bin/clion
nohup "$IDEA_DIR/bin/clion.sh" "$*" &> /dev/null &
