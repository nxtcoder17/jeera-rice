#! /usr/bin/env bash

function download_theme() {
	name=$1
	url=$2

	theme_path="themes/$name"
	[ -f "$theme_path" ] || curl -L0 "$url" >"$theme_path"
}

download_theme tokyonight-day.conf "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/kitty/tokyonight_day.conf"

download_theme papercolor-light.conf "https://raw.githubusercontent.com/craffate/papercolor-kitty/master/papercolor-light.conf"
