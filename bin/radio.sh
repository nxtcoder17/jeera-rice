#! /usr/bin/env bash

config_dir=${XDG_CONFIG_HOME:-~/.config}/radio # ~/.config/radio (default path)
log_dir=${XDG_DATA_HOME:-~/.cache}/radio       # ~/.local/share/radio (default path)
mkdir -p "$config_dir" "$log_dir"

config_file="$config_dir/sources.conf"
notification_icon="$XDG_CONFIG_HOME/dunst/radio-icon.png"

history_file="${log_dir}/history"
log_file=${log_dir}/log

if [ ! -e "$config_file" ]; then
  cat >"$config_file" <<EOF
# vim:set ft=conf:
# add radio sources below in this format
# name; stream-url; tag-k1: v1; tag-k2: v2; ...
# example:
# Kishore Kumar Radio; https://stream-148.zeno.fm/0ghtfp8ztm0uv?zs=JztLkJ9ISVqF29zPPjARrA; source=https://onlineradiofm.in/stations/city-kishore-kumar; group=artists; language=hindi
EOF
fi

# INFO: |+
# transformation logic:
# $1, would be station name
# $2, would be streaming URL
# substr($0, length($1) + length($2) + 1 + 1 + 1,length($0))
# $0 means the whole input line to awk
#   - 1st +1, for the delimiter between station name and streaming URL
#   - 2nd +1, for the delimiter between streaming URL and tags
#   - 3rd +1, for starting the substring from the next character

# grep '^[^#]' ~/.config/radio/sources.conf |  awk -F';' '{print $1 "\t" $2 "\t" gsub(substr($0, length($1) + length($2) + 1 + 1 + 1, length($0), ";\s", ";")}' | fzf --with-nth=1 --delimiter='\t' --preview="echo tags: {3}"

function choose_station() {
  sed -E 's/^\s+//g' -i "$config_file"
  grep '^[^#\s]' "$config_file" | tr ';' '\t' | fzf --with-nth=1 --delimiter='\t' || exit 0
}

# fzf --with-nth=1 --delimiter='\t' --preview="$previewer {2} {3}" --preview-window=right:70%:wrap --bind='enter:execute(mpv {2})' || exit 0

station="$(choose_station)"
[ -z "$station" ] && exit 0

function trim() {
  sed -E 's/^\s+//g'
}

station_name=$(echo "$station" | trim | awk -F'\t' '{print $1}')
url=$(echo "$station" | trim | awk -F'\t' '{print $2}' | trim)

echo "[📻 playing] $station_name (URL: $url)"

function notify_send() {
  while IFS= read -r line; do
    name=$(echo "$line" | awk -F'\t' '{print $3}')
    [ -n "$name" ] && notify-send --icon "$notification_icon" "$name" "$station_name"
    echo "$line"
  done </dev/stdin
}

# export -f notify_send

trap '( echo "killing ..."; kill $$ ) > /dev/null 2>&1 ' SIGINT SIGTERM EXIT

# function process_log() {
#   logline=$1
#   echo "log: $logline"
#   echo "$logline" | grep -i 'icy-title:' --line-buffered | sed -u -E 's/icy-title://g' | sed -u -E "s/^\s*/$(date -Is)\t$name\t/g" | notify_send | tee -a "$history_file"
#   echo "'$logline'" | awk '{printf "\r\033[K%s", $0; fflush()}'
# }
#
# export -f process_log
#
# function logging() {
#   echo 'RUNNING.......'
#   tail -f "$log_file" | xargs -I{} sh -c "process_log '{}'"
# }

# logging &

# mpv "$url" | tee "$logfile" | grep -i 'icy-title:' --line-buffered | sed -u -E 's/icy-title://g' | sed -u -E "s/^\s*/$(date -Is)\t$name\t/g" >> $history_file | tail -f "$logfile"

# mpv --cache=no "$url" | tee "$log_file" | grep -i 'icy-title:' --line-buffered | sed -u -E 's/icy-title://g' | sed -u -E "s/^\s*/$(date -Is)\t$name\t/g" | notify_send | tee -a "$history_file" | tail -f "$log_file"

mpv --cache=no "$url" | tee "$log_file" | grep -i 'icy-title:' --line-buffered | sed -u -E 's/icy-title://g' | sed -u -E "s/^\s*/$(date -Is)\t$name\t/g" | notify_send | tee -a "$history_file" | tail -f "$log_file" | awk '{printf "\r\033[K%s", $0; fflush()}'
