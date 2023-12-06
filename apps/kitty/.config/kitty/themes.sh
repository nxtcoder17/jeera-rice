#! /usr/bin/env bash

function download_theme() {
	name=$1
	url=$2

	theme_path="themes/$name"
	[ -f "$theme_path" ] || curl -L0 "$url" >"$theme_path"
}

download_theme tokyonight-day.conf "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/kitty/tokyonight_day.conf"

download_theme papercolor-light.conf "https://raw.githubusercontent.com/craffate/papercolor-kitty/master/papercolor-light.conf"

download_theme everforest-light.conf "https://gist.githubusercontent.com/sophiabrandt/da7ab58c3ac5e9283e98ba555329f535/raw/7f8dd978d805151350043b618ef19601c6a8a1a8/everforest-light-medium-kitty.conf"

download_theme github.conf "https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/Github.conf"

download_theme catppuccin-latte.conf "https://raw.githubusercontent.com/catppuccin/kitty/main/themes/latte.conf"

download_theme nightfox.conf "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/main/extra/nightfox/nightfox_kitty.conf"

download_theme terafox.conf "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/main/extra/terafox/nightfox_kitty.conf"
