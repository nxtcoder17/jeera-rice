#! /usr/bin/env bash

after_install() {
  keyboard-defaults.sh
}

cmd=$1
shift;

case $cmd in 
  "pacman")
    shells="bash fish"
    cli_tools="ripgrep fzf fd zoxide exa dust ncdu xclip tmux stow kitty btop make imagemagick xdg-user-dirs jq ranger picom tree github-cli"
    xwindow_stuffs="xclip xcape network-manager-applet"
    wm_tools="i3-wm i3blocks sysstat i3lock scrot dmenu rofi dunst feh sxiv xdotool wmctrl redshift lxappearance light screenkey"
    languages="nodejs npm go python python-pip python-pipx"
    browsers="firefox-developer-edition qutebrowser"
    messaging="telegram-desktop"
    fonts="noto-fonts-emoji ttf-croscore"
    audio="pulseaudio pulseaudio-alsa alsa-utils alsa-firmware alsa-plugins pamixer pavucontrol"
    codecs="ffmpeg faac faad2 libdca libmpeg2 opus x264 x265 gst-libav libtheora"
    video="mpv"
    touchpad="libinput xf86-input-libinput"
    battery="upower acpi"
    pdf="zathura zathura-pdf-mupdf pandoc"
    archives="unzip p7zip unrar tar"

    filesystems="ntfs-3g rclone"
    android="android-tools mtpfs gvfs-mtp"

    keyring="gnome-keyring libgnome-keyring"
    network="net-tools tcpdump wireless_tools wireguard-tools openresolv dog sshuttle"

    bluetooth="bluez bluez-utils pulseaudio-bluetooth blueman"
    gpu="nvtop"
    containers="nerdctl kubectl docker docker-buildx docker-compose helm"

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
      $containers

    xdg-user-dirs-update
    # sudo systemctl enable bluetooth.service
    # sudo systemctl restart bluetooth.service
    # after_install

    ;;
  "pipx")
    if command -v yq &> /dev/null; then 
      echo  "[#] yq, xq, tomlq already installed ✅"
    else
      pipx install yq
    fi

    if command -v ggshield &> /dev/null; then
      echo  "[#] ggshield already installed ✅"
    else
      pipx install ggshield
    fi

    if command -v pre-commit &> /dev/null; then
      echo  "[#] pre-commit already installed ✅"
    else
      pipx install pre-commit
    fi

    ;;
  "install-from-github-releases")
    bin_dir=$HOME/.local/bin
    mkdir -p $bin_dir

    pushd-

    # check if command exists
    if command -v upx &> /dev/null; then
      echo  "[#] upx already installed ✅"
    else
      dir=$(mktemp -d)
      pushd $dir > /dev/null 2>&1 || exit 
      printf "[#] installing upx ... "

      curl -L0 --silent https://github.com/upx/upx/releases/download/v4.0.2/upx-4.0.2-amd64_linux.tar.xz > upx.tar.xz && \
        tar xf upx.tar.xz && \
        mv upx-4.0.2-amd64_linux/upx $bin_dir && \
        echo "✅"
      popd > /dev/null 2>&1 || exit 
      rm -rf "$dir"
    fi

    if command -v task &> /dev/null; then
      echo  "[#] task already installed ✅"
    else
      dir=$(mktemp -d)
      pushd $dir > /dev/null 2>&1 || exit 
      printf "[#] installing task ... "
      curl -L0 --silent https://github.com/go-task/task/releases/download/v3.26.0/task_linux_amd64.tar.gz > task.tar.gz && \
        tar xf task.tar.gz && \
        mv task $bin_dir && \
        echo "✅"
      popd > /dev/null 2>&1 || exit 
      rm -rf "$dir"
    fi

    if command -v k9s &> /dev/null; then
      echo  "[#] k9s already installed ✅"
    else
      dir=$(mktemp -d)
      pushd $dir > /dev/null 2>&1 || exit 
      printf "[#] installing k9s ... "
      curl -L0 --silent https://github.com/derailed/k9s/releases/download/v0.27.4/k9s_Linux_amd64.tar.gz > k9s.tar.gz && \
        tar xf k9s.tar.gz && \
        mv k9s $bin_dir && \
        echo "✅"
      popd > /dev/null 2>&1 || exit 
      rm -rf "$dir"
    fi

    if command -v mongosh &> /dev/null; then
      echo  "[#] mongosh already installed ✅"
    else
      dir=$(mktemp -d)
      pushd $dir > /dev/null 2>&1 || exit 
      printf "[#] installing mongosh ... "
      curl -L0 --silent https://github.com/mongodb-js/mongosh/releases/download/v1.10.0/mongosh-1.10.0-linux-x64.tgz > mongosh.tar.gz && \
        tar xf mongosh.tar.gz && \
        mv mongosh-1.10.0-linux-x64/bin/mongosh $bin_dir && \
        echo "✅"
      popd > /dev/null 2>&1 || exit 
      rm -rf "$dir"
    fi

    if command -v rpk &> /dev/null; then
      echo  "[#] rpk already installed ✅"
    else
      dir=$(mktemp -d)
      pushd $dir > /dev/null 2>&1 || exit 
      printf "[#] installing rpk ... "
    curl -L0 --silent https://github.com/redpanda-data/redpanda/releases/latest/download/rpk-linux-amd64.zip > rpk.zip && \
      unzip rpk.zip && \
      mv rpk $bin_dir && \
      echo "✅"
      popd > /dev/null 2>&1 || exit 
      rm -rf "$dir"
    fi

    if command -v delta &> /dev/null; then
      echo  "[#] delta already installed ✅"
    else
      dir=$(mktemp -d)
      pushd $dir > /dev/null 2>&1 || exit 
      printf "[#] installing delta ... "
    curl -L0 --silent https://github.com/dandavison/delta/releases/download/0.16.5/delta-0.16.5-x86_64-unknown-linux-gnu.tar.gz > delta.tar.gz && \
      tar xf delta.tar.gz && \
      mv delta-0.16.5-x86_64-unknown-linux-gnu/delta $bin_dir && \
      echo "✅"
      popd > /dev/null 2>&1 || exit 
      rm -rf "$dir"
    fi

    ;;
  "yay")
    if command -v yay &> /dev/null; then
      echo  "[#] yay is already installed"
    else
      mkdir /tmp/x
      pushd /tmp/x || exit
      git clone https://aur.archlinux.org/yay.git
      cd yay || exit
      makepkg -si
      cd ..
      rm -rf yay
      popd || exit
    fi

    yay -S --needed \
      libinput-gestures \
      ntpsec \
      dragon-drop \
      google-chrome \
      mongodb-tools-bin \
      warpd

    # after_install
    ;;

  "rog")
    echo "should follow this guide: https://asus-linux.org/wiki/arch-guide/"
    # systemctl enable --now power-profiles-daemon.service
    # systemctl enable --now supergfxd
    ;;
  *)
    echo "supported commands: pacman|yay|rog|install-from-github-releases"
    ;;
esac

