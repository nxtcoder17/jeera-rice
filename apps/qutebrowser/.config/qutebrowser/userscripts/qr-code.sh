#! /usr/bin/env bash

tFile=$(mktemp --suffix=.png)
trap 'rm -rf "$tFile"' EXIT

qrencode -t PNG -o "$tFile" -s 10 "$QUTE_URL"
echo ":open -t file:///$tFile" >> "$QUTE_FIFO"
sleep 1
