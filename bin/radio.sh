#! /usr/bin/env bash

config_file="$XDG_CONFIG_HOME/radio/sources.conf" # ~/.config/radio/sources.conf (default path)

save_history=true
history_file="$XDG_DATA_HOME/radio/history" # ~/.local/share/radio/history (default path)
notification_icon="$XDG_CONFIG_HOME/dunst/radio-icon.png"

if [ ! -e "$config_file" ]; then
  mkdir -p "$(dirname $config_file)"
  cat > "$config_file" <<EOF 
# vim:set ft=conf:
# add radio sources below in this format
# name; stream-url; tag-k1: v1; tag-k2: v2; ...
# example:
# Kishore Kumar Radio; https://stream-148.zeno.fm/0ghtfp8ztm0uv?zs=JztLkJ9ISVqF29zPPjARrA; source=https://onlineradiofm.in/stations/city-kishore-kumar; group=artists; language=hindi
EOF
fi

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
# grep '^[^#]' "$config_file" |  awk -F';' '
# function trim(s) { 
#   return gensub(/^[ \t]+/, "", "g", s)
# }
# END{
#   name = trim($1)
#   url = trim($2)
#   printf("%s\t%s\t", name, url)
#   for(i=3; i < NF; ++i) {
#     printf("%s;", trim($i))
#   }
#   printf("%s\n", trim($NF))
# }' | fzf --with-nth=1 --delimiter='\t'|| exit 0
  sed -E 's/^\s+//g' -i "$config_file"
  grep '^[^#\s]' "$config_file" | tr ';' '\t' | fzf --with-nth=1 --delimiter='\t' || exit 0
}

# fzf --with-nth=1 --delimiter='\t' --preview="$previewer {2} {3}" --preview-window=right:70%:wrap --bind='enter:execute(mpv {2})' || exit 0

station="$(choose_station)"
[ -z "$station" ] && exit 0

function trim() {
  if [ -n "$1" ]; then
    echo "$1" | sed -E 's/^\s+//g'
    return
  fi
  # cat - | sed -E 's/^\s+//g'
  sed -E 's/^\s+//g'
}

station_name=$(echo "$station" | trim | awk -F'\t' '{print $1}' )
url=$(echo "$station"  | trim | awk -F'\t' '{print $2}' | trim)

if [ "$save_history" = true ]; then
  mkdir -p "$(dirname $history_file)"
fi

# echo "+------------------------------------------------------------------+" >> "$history_file"
# echo "[📻 playing] $name" | tee -a "$history_file"
# echo "[stream url] $url"  | tee -a "$history_file"
echo "[📻 playing] $station_name"
echo "[stream url] $url"
# echo "+------------------------------------------------------------------+" >> "$history_file"
#
# function send_notifications() {
#   while IFS= read -r line; do
#     # echo "[#]: line: $line"
#
#     name=$(echo "$line" | awk -F'\t' '{print $3}' )
#     # echo "[#]: name: $name"
#     [ -n "$name" ] && notify-send.sh --icon "$notification_icon" "$name" "$station_name"
#   done
# }

function notify_send() {
  while IFS= read -r line; do
    echo "[#]: line: $line" >> /tmp/subs

    name=$(echo "$line" | awk -F'\t' '{print $3}' )
    # echo "[#]: name: $name"
    [ -n "$name" ] && notify-send.sh --icon "$notification_icon" "$name" "$station_name"
    echo "$line"
  done < /dev/stdin
}

# trap 'kill $(jobs -p)' EXIT
# trap "trap - SIGTERM && kill -- -\$$" SIGINT SIGTERM EXIT
trap '( echo "killing ..."; kill $$ ) > /dev/null 2>&1 ' SIGINT SIGTERM EXIT
# tail -n 0 -f $history_file | send_notifications &

logfile=$(mktemp --suffix=.radiolog)
# mpv "$url" | tee "$logfile" | grep -i 'icy-title:' --line-buffered | sed -u -E 's/icy-title://g' | sed -u -E "s/^\s*/$(date -Is)\t$name\t/g" >> $history_file | tail -f "$logfile"
mpv "$url" | tee "$logfile" | grep -i 'icy-title:' --line-buffered | sed -u -E 's/icy-title://g' | sed -u -E "s/^\s*/$(date -Is)\t$name\t/g" | notify_send >> $history_file | tail -f "$logfile"
# mpv "$url"
