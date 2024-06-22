#! /usr/bin/env bash

theme=$(echo -e "light\ndark" | fzf --prompt="Choose Your Theme>")

echo -e "${theme}" >~/.system-theme

if [ "$theme" == "light" ]; then
	# change kitty theme
	ln -sf ~/.config/kitty/themes/dayfox.conf ~/.config/kitty/themes/light-or-dark-theme.conf

	# change i3 theme
	ln -sf ~/.config/i3/light-theme.conf ~/.config/i3/theme.conf

	# change i3blocks theme
	ln -sf ~/.config/i3blocks/light-theme.config ~/.config/i3blocks/config

	# change shell theme
	ln -sf ~/.config/fish/themes/dayfox.fish ~/.config/fish/themes/light-or-dark-theme.fish

	# change k9s theme
	ln -sf ~/.config/k9s/skins/catppuccin-latte.yaml ~/.config/k9s/skins/light-or-dark.yaml

	# change vim theme
	# echo 'require("plugins.colorschemes.nightfox.dayfox")' >~/.config/nvim/lua/plugins/colorschemes/nightfox/init.lua
	echo 'vim.opt.background = "light"' >~/.config/nvim/lua/theme.lua

	# change wallpaper
	feh --bg-tile ~/me/jeera-rice/wallpapers/zephyrus.png

	# change kitty background
	ln -sf ~/me/jeera-rice/wallpapers/paper-backgrounds/white-paper.png ~/.cache/kitty-background.png

	# change tmux theme
	ln -sf ~/.config/tmux/themes/slant-boxes-light.bash ~/.config/tmux/themes/slant-boxes-light-or-dark.bash
fi

if [ "$theme" == "dark" ]; then
	# change kitty theme
	ln -sf ~/.config/kitty/themes/nightfox.conf ~/.config/kitty/themes/light-or-dark-theme.conf

	# change i3 theme
	ln -sf ~/.config/i3/dark-theme.conf ~/.config/i3/theme.conf

	# change i3blocks theme
	ln -sf ~/.config/i3blocks/dark-theme.config ~/.config/i3blocks/config

	# change shell theme
	ln -sf ~/.config/fish/themes/nightfox.fish ~/.config/fish/themes/light-or-dark-theme.fish

	# change k9s theme
	ln -sf ~/.config/k9s/skins/nightfox.yaml ~/.config/k9s/skins/light-or-dark.yaml

	# change vim theme
	# echo 'require("plugins.colorschemes.nightfox.nightfox")' >~/.config/nvim/lua/plugins/colorschemes/nightfox/init.lua
	echo 'vim.opt.background = "dark"' >~/.config/nvim/lua/theme.lua

	# change wallpaper
	feh --bg-tile ~/me/jeera-rice/wallpapers/black-and-white-river.jpeg

	# change kitty background
	ln -sf ~/me/jeera-rice/wallpapers/paper-backgrounds/darkblue-paper.png ~/.cache/kitty-background.png

	# change tmux theme
	ln -sf ~/.config/tmux/themes/slant-boxes-dark.bash ~/.config/tmux/themes/slant-boxes-light-or-dark.bash
fi
