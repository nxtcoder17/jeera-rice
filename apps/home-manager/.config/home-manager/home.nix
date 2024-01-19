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

    # image viewers
    feh
    sxiv

    dunst
    light

    kitty
    networkmanagerapplet
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
    nerdctl
  ];

  packages.cli_workflow = with pkgs; [
    # shells
    fish
    bash

    # navigation
    zoxide
    eza
    ripgrep
    fd
    fzf

    # commonly used tools
    du-dust
    tmux
    bat
    btop
    ranger
    stow
    git
    redshift
    axel
    nix-direnv
    yq
    jq
    delta
    go-task
    pv # pipe viewer

    # http load testing
    nghttp2 # for h2load

    # networking
    inetutils
    netcat-gnu
    sshuttle
    wirelesstools

    # mouse control
    warpd

    # database cli tools
    mongosh

    # global programming languages support 
    nodejs-slim
    nodePackages.npm

    go_1_21
    gnumake
    gcc13
  ];

  packages.gui_apps = with pkgs; [
    telegram-desktop
    google-chrome
  ];

  # package_groups = {
  #   kubernetes = {};
  # };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nxtcoder17";
  home.homeDirectory = "/var/home/nxtcoder17";

  nixpkgs =  {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # home.i3wm = with pkgs; [
  #   i3
  #   i3blocks
  #   scrot
  #   dmenu-rs
  # ];

  # home.kubernetes = with pkgs; [
  #   kubernetes-helm
  # ];

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

    wezterm
    blackbox-terminal
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
    DIRENV_LOG_FORMAT = "";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.wezterm.package = nixGLWrap pkgs.wezterm;
  programs.kitty.package = nixGLWrap pkgs.kitty;
}
