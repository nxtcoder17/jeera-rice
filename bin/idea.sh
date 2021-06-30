#! /usr/bin/env bash

IDEA_DIR=$HOME/apps/idea
nohup "$IDEA_DIR/bin/idea.sh" "$*" &> /dev/null &
