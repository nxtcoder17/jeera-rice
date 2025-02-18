#! /usr/bin/env bash

nohup cursor --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=auto "$@" &>/dev/null &
