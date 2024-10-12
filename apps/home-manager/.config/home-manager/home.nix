# [Learn NIX](https://nixos.org/manual/nix/stable/language/)

{ config, pkgs, nixGLWrap, ... }:

let
  packages.xorg = with pkgs; [
    xorg.xrandr
    xorg.xset
    xcape
    xorg.xmodmap
    xorg.setxkbmap
    xorg.xhost
    xorg.xinput
    xorg.xkill
    lxappearance

    xclip
    xdragon
  ];

  packages.i3wm = with pkgs; [
    i3
    i3blocks
    scrot
    dmenu-rs
    sysstat
    rofi
    acpi

    # wayfire window manager
    wayfire-with-plugins

    # image viewers
    feh
    sxiv

    dunst
    light

    kitty
    networkmanagerapplet
    networkmanager

    keyd
    waybar
  ];

  packages.audio_video = with pkgs; [
    blueman
    pavucontrol
    pamixer

    mpv
  ];

  packages.kubernetes = with pkgs; [
    kubernetes-helm
    kubectl
    k9s

    (writeShellScriptBin "k3d" ''
      #! /usr/bin/env bash
      if [ ! -f "~/.local/bin/k3d" ]; then
        echo "Downloading k3d..."
        curl -L0 https://github.com/k3d-io/k3d/releases/download/v5.6.3/k3d-linux-amd64 > ~/.local/bin/k3d
        chmod +x ~/.local/bin/k3d
      fi
      ~/.local/bin/k3d "$@"
    '')

    nerdctl
    rootlesskit
    buildkit
    docker-buildx # copy $HOME/.nix-profile/bin/docker-buildx to $XDG_CONFIG_DIR/docker/cli-plugins/docker-buildx
    docker-compose # cp $HOME/.nix-profile/bin/docker-compose $XDG_CONFIG_DIR/docker/cli-plugins/docker-compose
    docker-slim
    dive

    awscli2
    lens

    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    azure-cli
  ];

  packages.cli_workflow = with pkgs; [
    (writeShellScriptBin "nvim" ''
      #! /usr/bin/env bash
      dest=$HOME/.local/tars.uz/nvim
      if ! command -v $dest/bin/nvim  &> /dev/null; then
      	rm -rf $dest
        echo "Downloading neovim..."
        dir=$(mktemp -d)
        trap "rm -rf $dir" EXIT
        pushd $dir
        curl -L0 https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz > nvim.tar.gz
        tar xf nvim.tar.gz
        rm nvim.tar.gz
        mv nvim-linux64 $dest
        popd
      fi
       $dest/bin/nvim "$@"
    '')

    (writeShellScriptBin "fwatcher" ''
      #! /usr/bin/env bash
      fwatcher_bin=$HOME/.local/bin/fwatcher
      if ! command -v $fwatcher_bin  &> /dev/null; then
        echo "Downloading fwatcher..."
        curl -L0 https://github.com/nxtcoder17/fwatcher/releases/latest/download/fwatcher-linux-amd64 > $fwatcher_bin
        chmod +x $fwatcher_bin
      fi
       $fwatcher_bin "$@"
    '')

    # shells
    fish
    fishPlugins.autopair
    # fishPlugins.hydro

    gitstatus
    bash
    readline
    ncdu

    # navigation
    zoxide
    eza
    ripgrep
    fd
    fzf
    proximity-sort

    # commonly used tools
    du-dust
    tmux
    zellij
    bat
    btop
    ranger
    stow
    git
    redshift
    axel
    yq
    jq
    delta
    pv # pipe viewer
    gh

    # http load testing
    nghttp2 # for h2load

    # networking
    inetutils
    netcat-gnu
    dogdns
    sshuttle
    wirelesstools
    nmap
    socat

    # mouse control
    warpd

    # database cli tools
    mongosh
    mycli
    redli

    # global programming languages support 
    nodejs-slim
    nodePackages.npm

    go_1_22
    gopls
    gnumake
    gcc13
    git-filter-repo
    upx

    universal-ctags
    lz4
    lrzip

    # cloudflare-warp
    nix-serve-ng
    hyperfine

    # pdf
    pdftk
  ];

  packages.gui_apps = with pkgs; [
    telegram-desktop
    google-chrome
    screenkey

    # vivaldi
    vivaldi-ffmpeg-codecs

    freshfetch

    fontforge-gtk
    vlc
    zathura

    copyq

    # zed-editor
    (writeShellScriptBin "zed" ''
      #! /usr/bin/env bash
      if [ ! -x "$HOME/.local/bin/zed" ]; then
        echo "Downloading zed..."
        dir="$HOME/.local/tars.uz"
        echo mkdir -p $dir
        mkdir -p $dir
        curl -L0 https://github.com/zed-industries/zed/releases/download/v0.145.1-pre/zed-linux-x86_64.tar.gz > $dir/zed.tar.gz
        ls -al $dir
        tar xf $dir/zed.tar.gz -C $dir
        ln -sf $dir/zed-preview.app/bin/zed $HOME/.local/bin/zed
      fi
      $HOME/.local/bin/zed "$@"
    '')

    (writeShellScriptBin "discord" ''
      #! /usr/bin/env bash
      name="discord"
      if ! flatpak list | awk -F \t '{print $2}' | grep -i $name 2>/dev/null; then
        echo "Downloading $name"
        flatpak install flathub com.discordapp.Discord
      fi
      flatpak run com.discordapp.Discord "$@"
    '')
  ];
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nxtcoder17";
  home.homeDirectory = "/var/home/nxtcoder17";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;[
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # wezterm
    # blackbox-terminal
    cargo
    glibcLocales
  ]
  ++ packages.xorg
  ++ packages.i3wm
  ++ packages.audio_video
  ++ packages.cli_workflow
  ++ packages.kubernetes
  ++ packages.gui_apps
  ;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nxtcoder17/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    TMUX_SHELL = "${pkgs.fish}";
    # TMUX_SHELL = "fish";
    #DIRENV_LOG_FORMAT = "\033[2mdirenv: %%s\033[0m"; # source: https://ianthehenry.com/posts/how-to-learn-nix/nix-direnv/
    #DIRENV_LOG_FORMAT = ""; # source: https://ianthehenry.com/posts/how-to-learn-nix/nix-direnv/
    NIXOS_OZONE_WL = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.wezterm.package = nixGLWrap pkgs.wezterm;
  programs.kitty.package = nixGLWrap pkgs.kitty;

  # programs.firefox-devedition-bin.package = nixGLWrap pkgs.firefox-devedition-bin;
}
