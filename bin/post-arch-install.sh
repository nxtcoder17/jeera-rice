#! /usr/bin/env bash

after_install() {
  keyboard-defaults.sh
}

cmd=$1
shift;

case $cmd in 
  "pacman")
    shells="bash fish"
    cli_tools="ripgrep fzf fd zoxide exa dust ncdu xclip tmux stow kitty btop make imagemagick xdg-user-dirs jq"
    xwindow_stuffs="xclip xcape network-manager-applet"
    wm_tools="i3-wm i3blocks sysstat i3lock scrot dmenu rofi dunst feh sxiv xdotool wmctrl redshift lxappearance"
    languages="nodejs npm go python"
    browsers="firefox-developer-edition"
    messaging="telegram-desktop"
    fonts="noto-fonts-emoji"
    audio="pulseaudio pulseaudio-alsa alsa-utils alsa-firmware alsa-plugins pamixer pavucontrol"
    codecs="ffmpeg faac faad2 libdca libmpeg2 opus x264 x265 gst-libav libtheora"
    video="mpv"
    touchpad="libinput xf86-input-libinput"
    battery="upower acpi"
    pdf="zathura zathura-pdf-mupdf pandoc"
    archives="unzip p7zip unrar tar"

    filesystems="ntfs-3g"
    android="android-tools mtpfs gvfs-mtp"

    keyring="gnome-keyring libgnome-keyring"
    network="net-tools tcpdump"

    bluetooth="bluez bluez-utils pulseaudio-bluetooth"
    gpu="nvtop"
    kubernetes="kubectl"

    sudo pacman -S --needed \
      $shells \
      $cli_tools \
      $xwindow_stuffs \
      $wm_tools \
      $languages \
      $browsers \
      $messaging \
      $fonts \
      $audio \
      $codecs \
      $video \
      $touchpad \
      $battery \
      $pdf \
      $archives \
      $filesystems \
      $android \
      $keyring \
      $network \
      $bluetooth \
      $gpu \
      $kubernetes

    xdg-user-dirs-update
    # sudo systemctl enable bluetooth.service
    # sudo systemctl restart bluetooth.service
    # after_install
    ;;
  "yay")
    if command -v yay &> /dev/null; then
      echo  "[#] yay is already installed"
    else
      mkdir /tmp/x
      pushd /tmp/x
      git clone https://aur.archlinux.org/yay.git
      cd yay
      makepkg -si
      cd ..
      rm -rf yay
      popd
    fi

    yay -S --needed \
      libinput-gestures \
      ntpsec

    # after_install
    ;;

  "rog")
    echo "should follow this guide: https://asus-linux.org/wiki/arch-guide/"
    # systemctl enable --now power-profiles-daemon.service
    # systemctl enable --now supergfxd
    ;;
  *)
    echo "supported commands: pacman|yay"
    ;;
esac

