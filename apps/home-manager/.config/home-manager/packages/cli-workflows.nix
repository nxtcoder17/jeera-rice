{ pkgs }: with pkgs; [
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
    bat
    btop

    ranger
    ueberzugpp # for ranger image preview

    #yazi-unwrapped
    stow
    git
    # redshift
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
]
