#! /usr/bin/env bash

FIREFOX_DIR=$HOME/apps/x-bin/firefox
CMD="systemd-run --user --slice=firefox.slice $FIREFOX_DIR/firefox-bin"
N_CMD="$FIREFOX_DIR/firefox-bin"

nohup $N_CMD &> /dev/null &
