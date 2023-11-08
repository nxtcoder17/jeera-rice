#! /usr/bin/env bash

function download_theme() {
	name=$1
	url=$2

	theme_path="themes/$name"
	[ -f "$theme_path" ] || curl -L0 "$url" >"$theme_path"
}

download_theme tokyonight-day.fish "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/fish/tokyonight_day.fish"
