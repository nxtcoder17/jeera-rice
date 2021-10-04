#! /usr/bin/env sh

ffmpeg -f x11grab -video_size 3840x2160  -framerate 25 -i $DISPLAY -c:v ffvhuff "$1".mkv
