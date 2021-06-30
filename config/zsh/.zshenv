# Usual
export EDITOR="nvim"
export PAGER="less"
export EMAIL="nxtcoder17@gmail.com"
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.local/share/go/bin:$HOME/.local/share/local-node/bin"
export PATH="$PATH:$HOME/.local/bin/mnpm"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --smart-case --ignore-file-case-insensitive ~/.ignore"

# XDG Directive

export XDG_DATA_HOME="$HOME/.local/share";
export XDG_CACHE_HOME="$HOME/.cache";
export XDG_CONFIG_HOME="$HOME/.config";

# ZSH
export ZDOTDIR=$XDG_CONFIG_HOME/zsh


## Clean Up
export XAUTHORITY="$XDG_RUNTIME_DIR/xauthority"
export LESSHISTFILE='-'
export INPUTRC="$XDG_CONFIG_HOME/inputrc"

## Application Specific
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export GOPATH="$XDG_DATA_HOME/go"
export K9SCONFIG="$XDG_CONFIG_HOME"/k9s
export MOST_INITFILE="$XDG_CONFIG_HOME"/mostrc
export MPLAYER_HOME="$XDG_CONFIG_HOME"/mplayer
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history 
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export NPM_CONFIG_TMP=$XDG_RUNTIME_DIR/npm
export NPM_CONFIG_STORE_DIR=$XDG_DATA_HOME/npm-pnpm

export _JAVA_OPTIONS=-DJava.util.prefs.userRoot=$XDG_CONFIG_HOME/java


