#! /usr/bin/env bash

exec warpd -f -c ~/.config/warpd/config --hint &
source keyboard-defaults.sh
