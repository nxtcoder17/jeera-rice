set fish_greeting

# if test (command -v exa | wc -l) -gt 0
if type -q exa 
    alias ls 'exa --icons'
    alias ll 'exa -la --icons'
end

# git abbreviations
abbr gs 'git status'
abbr gss 'git status -s'
abbr nv 'nvim'


alias k 'kubectl'
alias k9s 'k9s --logoless --headless -c ns'
alias cc 'xclip -sel clip'
alias ls 'ls -FG'
alias rm 'rm -i'

if type -q kubie
    alias kx 'kubie ctx'
end

if [ -f "$__fish_config_dir/nxtfns.fish" ]
    source "$__fish_config_dir/nxtfns.fish"
end

function addToPath --description "add item to system path"
    for item in $argv
        contains $item $PATH or set -x PATH $PATH $item
    end
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # constant Environments
    set -gx EDITOR nvim
    set -gx PAGER less
    set -gx EMAIL "nxtcoder17@gmail.com"
    set -gx BROWSER "firefox"

    set -gx XDG_DATA_HOME "$HOME/.local/share"
    set -gx XDG_CACHE_HOME "$HOME/.cache"
    set -gx XDG_CONFIG_HOME "$HOME/.config"

    set -gx XINITRC "$XDG_CONFIG_HOME/x11/xinitrc"
    set -gx INPUTRC "$XDG_CONFIG_HOME/inputrc"

    # APPLICATION specifics
    
    set -gx GOPATH "$XDG_DATA_HOME/go"
    set -gx K9SCONFIG "$XDG_CONFIG_HOME/k9s"
    set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
    set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    set -gx _JAVA_OPTIONS "-DJava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"

    set -gx NODE_REPL_HISTORY "$XDG_DATA_HOME/node_repl_history"
    set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
    set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
    set -gx NPM_CONFIG_TMP "$XDG_RUNTIME_DIR/npm"
    set -gx NPM_CONFIG_STORE_DIR "$XDG_DATA_HOME/node/bin"
    


    # set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --smart-case"

    set -gx GPG_TTY (tty) # to make GPG work

    #--------------------------------------------------
    addToPath /usr/local/bin
    addToPath $HOME/.local/bin $HOME/.local/jeera-rice/bin

    # node js global install packages
    addToPath $XDG_DATA_HOME/node/bin
    
    # go install binaries
    addToPath $XDG_DATA_HOME/go/bin
end

set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block

fish_vi_key_bindings

function edit_cmd --description 'Input command in external editor'
    set -l f (mktemp /tmp/fish.cmd.XXXXXXXX)
    if test -n "$f"
        set -l p (commandline -C)
        commandline -b > $f
        nvim -c 'set ft=fish' $f
        commandline -r (more $f)
        commandline -C $p
        command rm $f
    end
end

function fish_user_key_bindings
    bind \ce 'edit_cmd'
    bind -M insert \ce 'edit_cmd'
end

