#! /usr/bin/env bash

laptop=eDP-1-1
monitor=HDMI-1-2
monitorMode="2560x1440"


cmd=$1
shift 1;
case $cmd in 
  only-monitor)
    xrandr --output $monitor --mode $monitorMode --auto && xrandr --output $laptop --off
    [ -f ~/.fehbg ] && source ~/.fehbg
    ;;
  only-laptop)
    xrandr --output $laptop --auto && xrandr --output $monitor --off
    [ -f ~/.fehbg ] && source ~/.fehbg
    ;;
  left-right)
    xrandr --output $laptop --auto
    xrandr --output $monitor --right-of $laptop --mode $monitorMode --auto
    [ -f ~/.fehbg ] && source ~/.fehbg
    ;;
  *)
    item=$(echo -e "only-monitor\nonly-laptop\nleft-right" | dmenu)
    eval $0 $item
    ;;
esac
