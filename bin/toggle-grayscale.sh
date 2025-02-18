#! /usr/bin/env bash

hyprshade toggle grayscale

handle() {
  echo "event: $1"
  case $1 in
  activewindow\>*)
    echo "$1" | grep -i 'browser'
    status=$?
    if [ "$status" -eq 0 ]; then
      hyprshade off
    else
      hyprshade on grayscale
    fi
    ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
