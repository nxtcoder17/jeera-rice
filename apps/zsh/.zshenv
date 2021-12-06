#! /usr/bin/env zsh

# Usual
export EDITOR="nvim"
export PAGER="less"
export EMAIL="nxtcoder17@gmail.com"
export BROWSER="firefox"

# export PATH="$HOME/apps/bin:$PATH"
# export PATH="$HOME/apps/jeera-rice/bin:$PATH"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --smart-case"

# XDG Directive
export XDG_DATA_HOME="$HOME/.local/share";
export XDG_CACHE_HOME="$HOME/.cache";
export XDG_CONFIG_HOME="$HOME/.config";

# x11
export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"

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

## Less
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"

export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export NPM_CONFIG_TMP=$XDG_RUNTIME_DIR/npm
export NPM_CONFIG_STORE_DIR=$XDG_DATA_HOME/node-pkg

export _JAVA_OPTIONS=-DJava.util.prefs.userRoot=$XDG_CONFIG_HOME/java
