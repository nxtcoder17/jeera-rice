#! /usr/bin/env bash

pid=""

pid_file=/tmp/xremap/pid
if [ -f "$pid_file" ]; then
  pid=$(cat $pid_file)
fi

[ -n "$pid" ] && (kill -9 "$pid" || echo "no such process")

config_file="/home/nxtcoder17/.config/xremap/config.yml"

# xremap $config_file \
#   --device "CX 2.4G Wireless Receiver Keyboard" \
#   --device "Asus Keyboard" \
#   --device "BY Tech Gaming Keyboard"

xremap $config_file &
pid=$!
echo "$pid" > "$pid_file"
wait $pid
