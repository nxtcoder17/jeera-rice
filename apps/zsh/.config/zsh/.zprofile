# add this line, $ZDOTDIR/zprofile at top of /etc/zsh/zprofile

# load bin directories from $XDG_DATA_HOME
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/node/bin:$PATH"
export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/go/bin:$PATH"

# apps bin in path
export PATH="$HOME/apps/jeera-rice/bin:$PATH"
