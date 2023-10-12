#! /usr/bin/env bash

shells="fish"
pdf="zathura"
shell_utils="which"
containers="docker docker-buildx docker-compose helm k9s kubectl"
archive="unzip tar unrar"
network="net-tools inetutils tcpdump dog sshuttle wireguard-tools rclone"
monitoring="htop nvtop btop"
xwindow="xclip xcape sxiv xorg-xmodmap xorg-setxkbmap"
dev="ripgrep fzf fd exa zoxide dust ncdu tmux stow make imagemagick xdg-user-dirs jq ranger picom tree github-cli lsof terraform gcc"

sudo pacman -S --noconfirm --needed \
	$shells \
	$shell_utils \
	$pdf \
	$containers \
	$archive \
	$network \
	$monitoring \
	$xwindow \
	$dev
