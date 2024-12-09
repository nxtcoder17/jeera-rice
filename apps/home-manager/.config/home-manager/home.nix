# [Learn NIX](https://nixos.org/manual/nix/stable/language/)

{ config, pkgs, lib, nvidiaVersion, runWithNvidiaGPU, nixGLWrap, ... }:

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
    xorg.libXcomposite
    lxappearance

    xclip
    xdragon

    # picom-pijulius

    # -- xcb related
    # xorg.xcbutil
    # xcb-util-cursor
    # xorg.xcbutilwm
    # xorg.xcbutilrenderutil
    # xorg.xcbutilkeysyms
    # xorg.libxcb
  ];

  packages.hyprland = with pkgs; [
    #hyprland
    hyprland-protocols


    hyprland-workspaces
    wofi
    swaynotificationcenter # swaync
    gtk3
    tilix
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    swaybg
    waybar

    wlprop
    dmenu-wayland
    rofi-wayland

    hyprlandPlugins.hyprexpo
    hyprcursor
    hyprlock
    wlogout
    hypridle
    hyprshot
    hyprshade

    ripdrag # for drag-and-drop (xdragon in Xorg)

    light
    networkmanager
    wev
    nwg-look
    gammastep
  ];

  packages.hardware_acceleration = with pkgs; [
    # read more at https://wiki.archlinux.org/title/Hardware_video_acceleration
    vdpauinfo
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
    # wayfire-with-plugins

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
    docker-buildx # POST-INSTALL: `sudo cp $HOME/.nix-profile/bin/docker-buildx $XDG_CONFIG_HOME/docker/cli-plugins/docker-buildx`
    docker-compose # POST-INSTALL: `sudo cp $HOME/.nix-profile/bin/docker-compose $XDG_CONFIG_HOME/docker/cli-plugins/docker-compose`
    docker-slim
    dive

    awscli2
    # lens

    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    # azure-cli
  ];

  packages.cli_workflow = with pkgs; [
    python312Packages.gtts
    networkmanager
    graphviz

    transmission_4
    jujutsu

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

    (stdenv.mkDerivation {
      name = "nvim2";
      pname = "nvim2";
      version = "08049f6";
      src = fetchurl {
        url = "https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz";
        sha256 = "sha256-n2luY11QO4ROTnjoiiK89RKnjyiL9HE3mvw9AAThUhc=";
      };
      buildInputs = [ bash subversion ];
      nativeBuildInputs = [ coreutils makeWrapper ];
      installPhase = ''
        mkdir -p $out/bin
        echo 'SOURCE:'
        tar xf $src
        ls -al $src

        echo "OUT:"
        ls -al $out
        cp -R nvim-linux64 $out/nvim
        ln -sf $out/nvim/bin/nvim $out/bin/nvim2
        # cp github-downloader.sh $out/bin/github-downloader.sh
        # wrapProgram $out/bin/github-downloader.sh \
        #   --prefix PATH : ${lib.makeBinPath [ bash subversion ]}
      '';
    }
    )

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

    (writeShellScriptBin "testing" ''
      #! /usr/bin/env bash
      mkdir -p $out
      echo "out is $out"
    '')

    nix-output-monitor
    nvd

    # shells
    fish
    zsh
    fishPlugins.autopair
    # fishPlugins.hydro

    gitstatus
    bash
    glibcLocales
    bash-completion
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
    yazi-unwrapped
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
    nodejs
    nodePackages.npm
    nodePackages.pnpm

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

    bun

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

    (writeShellScriptBin "zen-browser" ''
      #! /usr/bin/env bash
      dest=$HOME/.local/bin/zen-browser
      if ! command -v $dest &> /dev/null; then
        echo "Downloading zen browser..."
        curl -L0 https://github.com/zen-browser/desktop/releases/latest/download/zen-generic.AppImage > $dest
        chmod +x $dest
        popd
      fi
      $dest "$@"
    '')

    # (stdenv.mkDerivation {
    #   name = "zen-browser";
    #   pname = "zen-browser";
    #   version = "";
    #   src = fetchurl {
    #     url = "https://github.com/zen-browser/desktop/releases/latest/download/zen-generic.AppImage";
    #     sha256 = "";
    #   };
    #   buildInputs = [ bash ];
    #   nativeBuildInputs = [ coreutils makeWrapper ];
    #   installPhase = ''
    #     mkdir -p $out/bin
    #     cp -R nvim-linux64 $out/nvim
    #     ln -sf $out/nvim/bin/nvim $out/bin/nvim2
    #     # cp github-downloader.sh $out/bin/github-downloader.sh
    #     # wrapProgram $out/bin/github-downloader.sh \
    #     #   --prefix PATH : ${lib.makeBinPath [ bash subversion ]}
    #   '';
    # }
    # )


    # (stdenv.mkDerivation {
    #   name = "zen2";
    #   # pname = "zen2";
    #   src = fetchurl
    #     {
    #       url = "https://github.com/zen-browser/desktop/releases/latest/download/zen-generic.AppImage";
    #       sha256 = "sha256-ULs54/BuLzHhqnjgENgtpaP60uqir+kromJxekGq5d4=";
    #       curlOpts = "-L0";
    #     };
    #   # src = ":";
    #   buildPhase = ":";
    #   unpackPhase = ":";
    #   installPhase = ''
    #     mkdir -p $out/bin
    #     cp --remove-destination  $src $out/bin/zen-browser2
    #     echo "#! /usr/bin/env bash" > $out/bin/testing
    #     echo "echo $src" >> $out/bin/testing
    #     output=$(ls -al)
    #     output+=$(ls $src)
    #     output+="$(echo src size: $(du -hs $src))"
    #     # echo "echo $(ls $src)" >> $out/bin/testing
    #     # echo "echo $(file $src)" >> $out/bin/testing
    #     echo "echo $out/bin" >> $out/bin/testing
    #     echo "ls $out/bin" >> $out/bin/testing
    #     echo "echo $(du -hs $out/bin/zen-browser2)" >> $out/bin/testing
    #     chmod +x $out/bin/testing
    #     chmod +x $out/bin/zen-browser2
    #
    #     output+="$(echo output size: $(du -hs $out/bin/zen-browser2))"
    #     echo "echo '$output'" >> $out/bin/testing
    #   '';
    #
    #   meta = with lib; {
    #     homepage = "https://github.com/borkdude/babashka";
    #     description = "Clojure scripting interpreter";
    #     platforms = platforms.linux;
    #     maintainers = with maintainers; [ filthy-trender ];
    #   };
    #
    #   # installPhase = '' 
    #   #   mkdir -p $out/bin
    #   #   curl -L0 https://github.com/zen-browser/desktop/releases/latest/download/zen-generic.AppImage > $out/bin/zen-browser2
    #   #   chmod +x $out/bin/zen-browser2
    #   # '';
    #
    #   # meta = with pkgs.stdenv.lib; {
    #   #   description = "downloaded from github releases";
    #   #   platforms = platforms.linux;
    #   # };
    # })

    firefox-devedition
    # (nixGL firefox-devedition)

  ];

  packages.nxtcoder17 = with pkgs; [
    (runWithNvidiaGPU firefox-devedition)

    (writeShellScriptBin "with-gpu" ''
      #! /usr/bin/env bash
      echo "got from input (nvidia_version: ${nvidiaVersion})"
      # nvidia_version=$(cat /proc/driver/nvidia/version | grep NVRM | awk '{print $8}')
      # nixGLNvidia-$nvidia_version $@
    '')
  ];
in
{
  # imports = [
  #   # TODO: remove when https://github.com/nix-community/home-manager/pull/5355 gets merged:
  #   (builtins.fetchurl {
  #     url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
  #     sha256 = "01dkfr9wq3ib5hlyq9zq662mp0jl42fw3f6gd2qgdf8l8ia78j7i";
  #   })
  # ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nxtcoder17";
  home.homeDirectory = "/home/nxtcoder17";

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
  home.packages = with pkgs; [
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
  ++ packages.hyprland
  # ++ packages.xorg
  # ++ packages.i3wm
  ++ packages.audio_video
  ++ packages.cli_workflow
  ++ packages.kubernetes
  ++ packages.gui_apps
  ++ packages.hardware_acceleration
  ++ packages.nxtcoder17
  ;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # programs.chromium = {
  #   enable = true;
  #   package = (nixGL pkgs.chromium);
  # };


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
    # DIRENV_LOG_FORMAT = "\033[2mdirenv: %%s\033[0m"; # source: https://ianthehenry.com/posts/how-to-learn-nix/nix-direnv/
    DIRENV_LOG_FORMAT = ""; # source: https://ianthehenry.com/posts/how-to-learn-nix/nix-direnv/
    # NIXOS_OZONE_WL = "1";
    #LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    # LOCALES_ARCHIVE_GLIBC = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.wezterm.package = nixGLWrap pkgs.wezterm;
  programs.kitty.package = nixGLWrap pkgs.kitty;
  # programs.zen-browser.package = nixGLWrap pkgs.zen-browser;
  # programs.firefox.package = nixGLWrap pkgs.firefox;

  # programs.bash.completion.enable = true;
  # programs.bash.blesh.enable = true;
  # programs.bash.enableLsColors = true;

  # programs.firefox-devedition-bin.package = nixGLWrap pkgs.firefox-devedition-bin;
}
