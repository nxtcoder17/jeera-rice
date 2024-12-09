#! /usr/bin/env bash
pids=$(hyprctl -j clients | jq -j '.[] | "\(.pid) "')
for pid in "$pids"; do
    kill $pid
done
hyprctl dispatch exit
