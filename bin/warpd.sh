#! /usr/bin/env bash

exec warpd -f -c ~/.config/warpd/config --hint &
echo "hello"
source keyboard-defaults.sh
