set fish_greeting

# if test (command -v exa | wc -l) -gt 0
if type -q exa 
    alias ls 'exa --icons'
    alias ll 'exa -la --icons'
end

alias k 'kubectl'
alias k9s 'k9s --logoless --headless -c ns'
alias cc 'xclip -sel clip'

# git abbreviations
abbr gs 'git status'
abbr gss 'git status -s'

abbr nv 'nvim'

if type -q kubie
    alias kx 'kubie ctx'
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x XDG_DATA_HOME "$HOME/.local/share"
    set -x PATH $PATH $HOME/.local/bin $HOME/me/jeera-rice/bin
    set -x PATH $PATH "$XDG_DATA_HOME"
end

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
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

