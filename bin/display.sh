#! /usr/bin/env bash

# laptop=eDP-1-1
# monitor=HDMI-1-2
# monitorMode="2560x1440"

laptop=$(xrandr -q | grep -iE 'e?DP-?.*\bconnected\b' | awk '{print $1}')
monitor=$(xrandr -q | grep -iE 'HDMI-.*\bconnected\b' | awk '{print $1}')
monitorMode="3840x2160"

cmd=$1
shift 1
case $cmd in
only-monitor)
  xrandr --output $monitor --mode $monitorMode --auto --primary && xrandr --output $laptop --off
  # xrandr --output $monitor --mode $monitorMode --auto && xrandr --output $monitor --primary --left-of "$laptop"
  [ -f "$HOME"/.fehbg ] && source $HOME/.fehbg
  ;;
only-laptop)
  xrandr --output $laptop --auto && xrandr --output $monitor --off
  [ -f "$HOME"/.fehbg ] && source $HOME/.fehbg
  ;;
left-right)
  xrandr --output $laptop --auto
  xrandr --output $monitor --right-of $laptop --mode $monitorMode --auto
  [ -f $HOME/.fehbg ] && source $HOME/.fehbg
  ;;
*)
  item=$(echo -e "only-monitor\nonly-laptop\nleft-right" | dmenu)
  eval $0 $item
  ;;
esac
