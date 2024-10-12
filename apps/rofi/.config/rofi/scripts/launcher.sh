#! /usr/bin/env bash

# This script is used to launch applications, and switch windows in rofi.

rofi_global_opts="-matching fuzzy -sort-method fzf"

rofi "$rofi_global_opts" -show combi -modi drun,run,ssh -theme "$HOME"/.config/rofi/nxtcoder17/launcher.rasi
