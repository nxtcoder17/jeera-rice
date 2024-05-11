#! /usr/bin/env bash

theme=$(echo -e "light\ndark" | fzf --prompt="Choose Your Theme>")

if [ "$theme" == "light" ]; then
	# change kitty theme
	ln -sf ~/.config/kitty/themes/dayfox.conf ~/.config/kitty/themes/light-or-dark-theme.conf

	# change shell theme
	ln -sf ~/.config/fish/themes/dayfox.fish ~/.config/fish/themes/light-or-dark-theme.fish

	# change k9s theme
	ln -sf ~/.config/k9s/skins/catppuccin-latte.yaml ~/.config/k9s/skins/light-or-dark.yaml

	# change vim theme
	echo 'require("plugins.colorschemes.nightfox.dayfox")' >~/.config/nvim/lua/plugins/colorschemes/nightfox/init.lua

	# change wallpaper
	# ln -sf ~/me/jeera-rice/wallpapers/white-x.jpg ~/.light-or-dark-wallpaper.jpg
	ln -sf ~/me/jeera-rice/wallpapers/paper-backgrounds/white-paper.png ~/.light-or-dark-wallpaper.jpg
	feh --bg-tile ~/.light-or-dark-wallpaper.jpg

	# change tmux theme
	ln -sf ~/.config/tmux/themes/slant-boxes-light.bash ~/.config/tmux/themes/slant-boxes-light-or-dark.bash
fi

if [ "$theme" == "dark" ]; then
	# change kitty theme
	ln -sf ~/.config/kitty/themes/nightfox.conf ~/.config/kitty/themes/light-or-dark-theme.conf

	# change shell theme
	ln -sf ~/.config/fish/themes/nightfox.fish ~/.config/fish/themes/light-or-dark-theme.fish

	# change k9s theme
	ln -sf ~/.config/k9s/skins/nightfox.yaml ~/.config/k9s/skins/light-or-dark.yaml

	# change vim theme
	echo 'require("plugins.colorschemes.nightfox.nightfox")' >~/.config/nvim/lua/plugins/colorschemes/nightfox/init.lua

	# change wallpaper
	ln -sf ~/me/jeera-rice/wallpapers/Golden-Ripples-In-Deep-Blue-AI-Generated-4K-Wallpaper.jpg ~/.light-or-dark-wallpaper.jpg
	feh --bg-scale ~/.light-or-dark-wallpaper.jpg

	# change tmux theme
	ln -sf ~/.config/tmux/themes/slant-boxes-dark.bash ~/.config/tmux/themes/slant-boxes-light-or-dark.bash
fi
