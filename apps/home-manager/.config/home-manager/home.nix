{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nxtcoder17";
  home.homeDirectory = "/var/home/nxtcoder17";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

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

bat
btop
xorg.xrandr
xorg.xset
xcape
xorg.xmodmap
xorg.setxkbmap
xorg.xhost
xorg.xinput
# xfce.xfce4-i3-workspaces-plugin
pamixer

ranger

nodejs_20
nodePackages.pnpm

redshift
networkmanagerapplet
light
feh
lxappearance
# picom

terraform
# operator-sdk

# build-tools
gnumake
gnupatch
gcc

    stow
    git
    pipx
    deno
    # terraform
    tmux

  ripgrep
  fd
  fzf
  du-dust
  acpi
  # upower

fish
zoxide
eza
light
#firefox-devedition
# distrobox
# firefox
#kitty

# xfce.xfce4-session
# xfce.xfce4-notify
# xfce.xfce4-terminal
# xfce.xfce4-settings
# xfce.xfce4-appfinder
# xfce.xfce4-taskmanager
# xfce.xfce4-power-manager
# xfce.xfce4-clipman-plugin

# gnome.gnome-keyring
dunst

     blueman
      # chromium
      # deja-dup
      # drawing
      # elementary-xfce-icon-theme
      # evince
      # foliate
      # font-manager
      # gimp-with-plugins
      # gnome.file-roller
      # gnome.gnome-disk-utility
      # inkscape-with-extensions
      # libqalculate
      # libreoffice
      # orca
      pavucontrol
      # qalculate-gtk
      # thunderbird
      wmctrl
      xclip
      xcolor
      # xcolor
      xdo
      xdotool

      # xfce.catfish
      # xfce.gigolo
      # xfce.orage
      # xfce.xfburn
      # xfce.xfce4-appfinder
      # xfce.xfce4-clipman-plugin
      # xfce.xfce4-cpugraph-plugin
      # xfce.xfce4-dict
      # xfce.xfce4-fsguard-plugin
      # xfce.xfce4-genmon-plugin
      # xfce.xfce4-netload-plugin
      # xfce.xfce4-panel
      # xfce.xfce4-pulseaudio-plugin
      # xfce.xfce4-systemload-plugin
      # xfce.xfce4-weather-plugin
      # xfce.xfce4-whiskermenu-plugin
      # xfce.xfce4-xkb-plugin
      # xfce.xfce4-session
      # xfce.xfdashboard
      # xfce.xfdashboard
      # xfce.xfconf xorg.xev

      xsel
      xtitle
      # xwinmosaic
      zuki-themes

      i3
      i3blocks
      scrot
      dmenu-rs
      sysstat
      rofi

      k9s
      kubectl
      kubernetes-helm
      # docker
      docker-buildx
      # docker-compose
      go-task

# programming languages
# go
go_1_21
mongosh
upx
github-cli
  xdragon
pre-commit

  (python312.withPackages(ps: with ps; [
    ggshield
  ]))

telegram-desktop

inetutils
wireguard-tools
mpv
yq
redpanda
trivy
dive
brotli
s3rs
conky
lua54Packages.lpeg
awscli2
ntp
google-chrome
  ];

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

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

# services.picom.enable = true;


  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nxtcoder17/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim"; 
    TMUX_SHELL = "${pkgs.fish}";
    # LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # settings.experimental-features = [ "nix-command" "flakes" ];
}
