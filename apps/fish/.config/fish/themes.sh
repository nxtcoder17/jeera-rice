#! /usr/bin/env bash

dir=$(realpath "$(dirname "$0")")

function download_theme() {
	name=$1
	url=$2

	theme_path="$dir/themes/$name"
	[ -f "$theme_path" ] || curl -L0 "$url" >"$theme_path"
}

download_theme tokyonight-day.fish "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/fish/tokyonight_day.fish"

download_theme base16-edge.fish "https://raw.githubusercontent.com/tomyun/base16-fish/master/functions/base16-edge-light.fish"

download_theme base16-mocha.fish "https://raw.githubusercontent.com/tomyun/base16-fish/master/functions/base16-mocha.fish"

download_theme nightfox.fish "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/main/extra/nightfox/nightfox_fish.fish"

download_theme dayfox.fish "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/main/extra/dayfox/nightfox_fish.fish"

download_theme terafox.fish "https://raw.githubusercontent.com/EdenEast/nightfox.nvim/main/extra/terafox/nightfox_fish.fish"
