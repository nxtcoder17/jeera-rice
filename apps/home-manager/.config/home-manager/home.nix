# [Learn NIX](https://nixos.org/manual/nix/stable/language/)
{
  config,
  pkgs,
  lib,
  nvidiaVersion,
  runWithNvidiaGPU,
  withPostInstallScript,
  nixGLWrap,
  ...
}: let
  packages.xorg = with pkgs; [
    # xorg.xinit
    # xorg.xauth
    xorg.xrandr
    xorg.xset
    arandr
    xcape
    # xorg.xmodmap
    xorg.setxkbmap
    # xorg.xhost
    xorg.xinput
    xorg.xev

    # xorg.xkill
    # xorg.libXcomposite
    # lxappearance

    xclip
    xdragon
    sx # a simple alternative to xinit and startx

    picom-pijulius

    # -- xcb related
    # xorg.xcbutil
    # xcb-util-cursor
    # xorg.xcbutilwm
    # xorg.xcbutilrenderutil
    # xorg.xcbutilkeysyms
    # xorg.libxcb
    # xdg-desktop-portal
  ];

  packages.wayfire = with pkgs; [
    # wayfire-with-plugins
    # wlrobs
    xdg-desktop-portal-wlr
  ];

  packages.hyprland = with pkgs; [
    #hyprland
    hyprland-protocols
    hyprland-workspaces
    wofi
    swaynotificationcenter # swaync
    gtk3
    # tilix
    xdg-desktop-portal-hyprland
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
    nwg-look # lx appearance for wayland
    gammastep
    wf-recorder

    dart-sass
  ];

  packages.niri_wm = with pkgs; [
    (runWithNvidiaGPU niri)
  ];

  packages.linux = with pkgs; [
  ];

  packages.macos = with pkgs; [
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
    # rofi
    acpi

    # image viewers
    feh
    sxiv

    dunst
    light

    # (runWithNvidiaGPU kitty)
    networkmanagerapplet
    networkmanager

    # keyd
    # kanata
    lxappearance

    xdg-desktop-portal
    xdg-desktop-portal-gtk
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
    # k9s

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
    # ((withPostInstallScript docker-buildx) ''
    #   mkdir -p /home/nxtcoder17/.config/docker/cli-plugins
    #   cp $PACKAGE/bin/docker-buildx /home/nxtcoder17/.config/docker/cli-plugins/docker-buildx
    # '')
    docker-buildx # POST-INSTALL: `sudo cp $HOME/.nix-profile/bin/docker-buildx $XDG_CONFIG_HOME/docker/cli-plugins/docker-buildx`
    docker-compose # POST-INSTALL: `sudo cp $HOME/.nix-profile/bin/docker-compose $XDG_CONFIG_HOME/docker/cli-plugins/docker-compose`
    docker-slim
    dive

    awscli2
    podman-compose
    # lens

    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    # azure-cli

    # mkcert
    # (pkgs.stdenv.mkDerivation {
    #   pname = "nss_tools";
    #   version = "custom";
    #
    #   # No source, we're just copying from nss_latest
    #   src = ./.;
    #
    #   unpackPhase = ":";
    #   buildInputs = with pkgs; [nss_latest];
    #
    #   installPhase = ''
    #     ls -al ${pkgs.nss_latest}
    #     mkdir -p $out/bin
    #     cp ${pkgs.nss_latest}/tools/certutil $out/bin/
    #   '';
    # })
    nssTools
    iotop
  ];

  packages.ai_tools = with pkgs; [
    gemini-cli
    claude-code
  ];

  packages.cli_workflow = with pkgs; [
    bash
    bash-completion

    tldr
    networkmanager
    graphviz
    android-tools

    clamav
    # (runWithNvidiaGPU ghostty)

    transmission_4
    jujutsu
    # ags
    udp2raw

    # (writeShellScriptBin "fwatcher" ''
    #   #! /usr/bin/env bash
    #   fwatcher_bin=$HOME/.local/bin/fwatcher
    #   if ! command -v $fwatcher_bin  &> /dev/null; then
    #     echo "Downloading fwatcher..."
    #     curl -L0 https://github.com/nxtcoder17/fwatcher/releases/latest/download/fwatcher-linux-amd64 > $fwatcher_bin
    #     chmod +x $fwatcher_bin
    #   fi
    #    $fwatcher_bin "$@"
    # '')

    (stdenv.mkDerivation rec {
      name = "fwatcher";
      pname = "fwatcher";
      src = fetchurl {
        url = "https://github.com/nxtcoder17/fwatcher/releases/download/v1.0.2/fwatcher-linux-amd64";
        sha256 = "sha256-V5v0zfwkhInLEWouvjtXuW3kHuvMiLtA7eddHxsz1B4=";
      };
      unpackPhase = ":";
      installPhase = ''
        mkdir -p $out/bin
        cp $src $out/bin/$name
        chmod +x $out/bin/$name
      '';
    })

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

    # gitstatus
    bfg-repo-cleaner # helps in removing secrets already commited in git history
    # bash
    glibcLocales
    # bash-completion
    readline
    ncdu
    gum

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
    ueberzugpp # for ranger image preview

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

    go
    gopls
    golangci-lint
    # gnumake
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
    duf

    postgresql
    nushell
  ];

  packages.gui_apps = with pkgs; [
    graphite-gtk-theme
    graphite-cursors

    telegram-desktop
    google-chrome
    screenkey

    (runWithNvidiaGPU vivaldi)
    (runWithNvidiaGPU windsurf)
    # (runWithNvidiaGPU qutebrowser)
    vivaldi-ffmpeg-codecs

    freshfetch

    fontforge-gtk
    vlc
    zathura

    copyq
    # postman
    vscode

    gtk-engine-murrine

    # (runWithNvidiaGPU code-cursor)

    (runWithNvidiaGPU zed-editor)
    # (runWithNvidiaGPU en-croissant)

    stockfish

    # (writeShellScriptBin "zed" ''
    #   #! /usr/bin/env bash
    #   if [ ! -x "$HOME/.local/bin/zed" ]; then
    #     echo "Downloading zed..."
    #     dir="$HOME/.local/tars.uz"
    #     echo mkdir -p $dir
    #     mkdir -p $dir
    #     curl -L0 https://github.com/zed-industries/zed/releases/download/v0.145.1-pre/zed-linux-x86_64.tar.gz > $dir/zed.tar.gz
    #     ls -al $dir
    #     tar xf $dir/zed.tar.gz -C $dir
    #     ln -sf $dir/zed-preview.app/bin/zed $HOME/.local/bin/zed
    #   fi
    #   $HOME/.local/bin/zed "$@"
    # '')

    (writeShellScriptBin "discord" ''
      #! /usr/bin/env bash
      name="discord"
      if ! flatpak list | awk -F \t '{print $2}' | grep -i $name 2>/dev/null; then
        echo "Downloading $name"
        flatpak install flathub com.discordapp.Discord
      fi
      flatpak run com.discordapp.Discord "$@"
    '')

    (stdenv.mkDerivation rec {
      name = "sublime";
      pname = "sublime";
      src = fetchurl {
        url = "https://download.sublimetext.com/sublime_text_build_4180_x64.tar.xz";
        sha256 = "sha256-pl42AR4zWF3vx3wPSZkfIP7Oksune5nsbmciyJUv8D4=";
      };
      # unpackPhase = ":";
      buildInputs = with pkgs; [bash];
      installPhase = ''
        tar xf $src
        mkdir -p $out/bin $out/share/applications
        mv sublime_text $out/sublime-extract
        ln -sf $out/sublime-extract/sublime_text $out/bin/$name
        ln -sf $out/sublime-extract/sublime_text.desktop $out/share/applications/$name.desktop
      '';
    })

    # (runWithNvidiaGPU (stdenv.mkDerivation rec {
    #   name = "zen-browser";
    #   pname = name;
    #   version = "";
    #   src = fetchurl {
    #     url = "https://github.com/zen-browser/desktop/releases/latest/download/zen-x86_64.AppImage";
    #     sha256 = "sha256-GJuxooMV6h3xoYB9hA9CaF4g7JUIJ2ck5/hiQp89Y5o=";
    #
    #     # url = "https://github.com/zen-browser/desktop/releases/latest/download/zen-generic.AppImage";
    #     # sha256 = "sha256-Dy21dVatjyl9AiDm+SXEnoT+HMHCtTZehXUAyYKiUpU=";
    #   };
    #   unpackPhase = ":";
    #   buildInputs = with pkgs; [ bash unzip ];
    #   installPhase = ''
    #     mkdir -p $out/appimage $out/bin
    #     cp $src $out/appimage/$name
    #     chmod +x $out/appimage/$name
    #     pushd $out/appimage
    #     ./$name --appimage-extract
    #     popd
    #     ln -sf $out/appimage/squashfs-root/AppRun $out/bin/$name
    #   '';
    # }))

    # (runWithNvidiaGPU firefox-devedition)
    # (runWithNvidiaGPU jetbrains.idea-ultimate)
  ];

  packages.nxtcoder17 = with pkgs; [
    (writeShellScriptBin "with-gpu" ''
      #! /usr/bin/env bash
      echo "got from input (nvidia_version: ${nvidiaVersion})"
      # nvidia_version=$(cat /proc/driver/nvidia/version | grep NVRM | awk '{print $8}')
      # nixGLNvidia-$nvidia_version $@
    '')
  ];
in {
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
  nixpkgs.config.allowUnfreePredicate = _: true;

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
  home.packages = with pkgs;
    [
      cargo
      glibcLocales
      # rofi-wayland
      sassc
      # noto-fonts
      # noto-fonts-color-emoji
      # noto-fonts-monochrome-emoji
      # joypixels
      twemoji-color-font
    ]
    ++ packages.hyprland
    ++ packages.wayfire
    ++ packages.xorg
    ++ packages.i3wm
    ++ packages.audio_video
    ++ packages.cli_workflow
    ++ packages.ai_tools
    ++ packages.kubernetes
    ++ packages.gui_apps
    ++ packages.hardware_acceleration
    ++ packages.niri_wm
    ++ packages.nxtcoder17;

  programs.direnv = {
    enable = true;
    silent = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # programs.chromium = {
  #   enable = true;
  #   package = (nixGL pkgs.chromium);
  # };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/docker/cli-plugins/docker-compose" = {
      source = "${pkgs.docker-compose}/bin/docker-compose";
    };
    ".config/docker/cli-plugins/docker-buildx" = {
      source = "${pkgs.docker-buildx}/bin/docker-buildx";
    };
  };

  # xdg.configFile = {
  #     “nvim” = {
  #           source = config.lib.file.mkOutOfStoreSymlink “${dotty}/config/nvim”;
  #           recursive = true;
  #     };
  # };
  #

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
    # EDITOR = "nvim";
    # TMUX_SHELL = "${pkgs.fish}";
    # TMUX_SHELL = "fish";
    # DIRENV_LOG_FORMAT = "\033[2mdirenv: %%s\033[0m"; # source: https://ianthehenry.com/posts/how-to-learn-nix/nix-direnv/
    # DIRENV_LOG_FORMAT = ""; # source: https://ianthehenry.com/posts/how-to-learn-nix/nix-direnv/
    # NIXOS_OZONE_WL = "1";
    LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    # LOCALES_ARCHIVE_GLIBC = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    BASH_COMPLETION_SOURCE_DIR = "${pkgs.bash-completion}";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
