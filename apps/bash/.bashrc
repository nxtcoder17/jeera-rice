# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# bash shell history
HISTSIZE=100000
HISTFILESIZE=2000000
export HISTTIMEFORMAT="[%F %T] "
HISTCONTROL=ignorespace:ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# INFO: BASH history across different terminal sessions
# it saves command history as soon as we run them
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

function has_command() {
  command -v "$1" >/dev/null 2>&1
}

function source_if_exists() {
  file=$1
  [ -e "$file" ] && source "$file" || echo "failed to source $file"
}

export EDITOR='nvim'

# -------------------
# Section: Aliases
# -------------------

alias rm='rm -i'

if has_command exa; then
  alias ls='exa --icons'
  alias ll='exa --al --icons'
else
  alias ll='ls -al'
fi

alias gs='git status'
alias gss='git status -s'

alias vi='nvim'
alias vim='nvim'
alias k='kubectl'
alias k9s='k9s --logoless --headless -c ns'

has_command bat && alias cat='bat'

if has_command home-manager; then
  alias hm='home-manager'
  alias hme='home-manager edit'
  alias hms='home-manager switch'
fi

alias shell_reload='source ~/.bashrc'

# -------------------
# Section: Env Vars
# -------------------

export EDITOR=nvim
# export PAGER="nvim -R"
export MANPAGER='nvim +Man!'

# XDG Dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_STORE_DIR="$XDG_DATA_HOME/node/bin"
export GOPATH="$XDG_DATA_HOME/go"

export NIXY_EXECUTOR="bubblewrap"
export NIXY_USE_PROFILE="true"

function add_to_path() {
  for item in "${@}"; do
    export PATH="$item:$PATH"
  done
}

## zoxide exclude DIRS
export _ZO_EXCLUDE_DIRS=".secrets:archived:.dump:old"

export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --smart-case"

# to make GPG work with TTY input box
export GPG_TTY=$(tty)

# set -x LANGUAGE "en_US.UTF-8"
# set -x LC_ALL "en_US.UTF-8"
# set -x LANG "en_US.UTF-8"
# set -x LC_TYPE "en_US.UTF-8"

add_to_path "$HOME/me/jeera-rice/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$GOPATH/bin"
add_to_path "$HOME/workspace/github.com/kloudlite/internal-tools/bin"
add_to_path "$XDG_DATA_HOME/node/bin"
add_to_path "$XDG_DATA_HOME/bun/bin"
add_to_path "$XDG_DATA_HOME/pnpm"

[ "$(uname)" = "Darwin" ] && append_to_path "/opt/homebrew/bin"

export NIXY_EXECUTOR="bubblewrap"
export NIXY_USE_PROFILE="true"

# direnv hook fish  | source 2>&1 > /dev/null

# -------------------
# Section: Custom Functions
# -------------------

function cc() {
  if [ "$(uname)" = "Darwin" ]; then
    pbcopy
    return
  fi

  if [ "$(uname)" = "Linux" ]; then
    if [ "$XDG_BACKEND" = "wayland" ]; then
      wl-copy
      return
    else
      xclip -sel clip
      return
    fi
  fi
}

# choose kubeconfig
function ck() {
  dir="$HOME/.kube/configs"
  chosen_kubeconfig=$(command ls ~/.kube/configs | fzf --reverse --prompt "choose kubeconfig > ")

  [ -z "$chosen_kubeconfig" ] && unset KUBECONFIG && return
  export KUBECONFIG="$dir/$chosen_kubeconfig"
}

function mkcd() {
  mkdir -p $1 && cd $1
}

function mktempd() {
  dir=$(mktemp -d)
  cd "$dir"
}

function cht() {
  curl "cheat.sh/$1?\T"
}
# -------------------
# Section: KeyBindings
# -------------------

function edit_prompt() {
  # Save current command line to a temp file
  local tmpfile
  tmpfile=$(mktemp /tmp/bash-edit.XXXXXX)
  echo "$READLINE_LINE" >"$tmpfile"

  # Open in $EDITOR
  ${EDITOR:-vi} "$tmpfile"

  # Reload edited command into the prompt (don’t execute)
  READLINE_LINE=$(<"$tmpfile")
  READLINE_POINT=${#READLINE_LINE} # cursor at end
  rm -f "$tmpfile"
}
bind -x '"\C-e": edit_prompt'

# ----------------------------
# Section: Integrating with other tools
# ----------------------------

source <(fzf --bash)
source <(zoxide init bash)

if has_command nix; then
  source_if_exists "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

if has_command home-manager; then
  source_if_exists "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
#
# ----------------------------
# Section: run_on_prompt_render
# ----------------------------

function __git_info() {
  start=$(date +%s.%N) # seconds.nanoseconds
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local branch dirty
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)
  if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    dirty="*"
  fi
  end=$(date +%s.%N)
  elapsed_ms=$(echo "($end - $start) * 1000" | bc)
  echo "$branch$dirty(took $elapsed_ms)"
}

function __fast_git_info() {
  # Look for .git directory in current or parent dirs
  local gitdir
  gitdir=$(git rev-parse --git-dir 2>/dev/null) || return

  # Get branch name
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)
  [ -z "$branch" ] && branch="?"

  # Check if there are uncommitted changes
  local dirty=""
  if ! git diff --quiet --ignore-submodules --cached 2>/dev/null ||
    ! git diff --quiet --ignore-submodules 2>/dev/null; then
    dirty="*"
  fi

  echo "${YELLOW}($branch $dirty)${RESET}"
}

function __bash_prompt() {
  # Colors
  RED="\[\033[0;31m\]"
  GREEN="\[\033[0;32m\]"
  YELLOW="\[\033[0;33m\]"
  BLUE="\[\033[0;34m\]"
  RESET="\[\033[0m\]"

  prompt_char="ϟ"
  prompt_char="${GREEN}$prompt_char${RESET}"

  pwd="${BLUE}\w${RESET}"
  [ -n "$KUBECONFIG" ] && kubeconfig="(  $(basename $KUBECONFIG)) "

  [ -n "$IN_NIXY_SHELL" ] && nixy="[  NIXY] "

  source_if_exists ~/.config/fzf/themes/theme.bash

  # PS1="$kubeconfig$pwd ${YELLOW}($(__git_info))${RESET}
  PS1="$kubeconfig$pwd $(__fast_git_info)
$nixy$prompt_char "
}

function __debug_performance() {
  local start end elapsed_ms
  start=$(date +%s.%N) # seconds.nanoseconds
  "${@}"
  end=$(date +%s.%N) # seconds.nanoseconds
  elapsed_ms=$(echo "($end - $start) * 1000" | bc)
  echo "$1 took: $elapsed_ms ms"
}

__last_dir=""
function __nixy_shell() {
  [ "$__last_dir" = "$PWD" ] && return
  [ -n "$IN_NIXY_SHELL" ] && return
  __last_dir="$PWD"
  [ -e "$PWD/nixy.yml" ] && nixy shell
}

function __run_on_prompt_render() {
  # INFO: to debug performance issue of a function prefix it with __debug_performance
  __bash_prompt
  __nixy_shell
}

# hook into prompt rendering
PROMPT_COMMAND="__run_on_prompt_render${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
bind "set menu-complete-display-prefix on"

# shell completion

source_if_exists "$BASH_COMPLETION_DIR/etc/profile.d/bash_completion.sh"

# Only run fish for interactive sessions
# case "$-" in
# *i*)
#   if has_command fish && [ -e "" ]; then
#     exec fish
#   fi
#   ;;
# esac
