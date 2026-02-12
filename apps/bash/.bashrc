# If not running interactively, don't do anything
if [ -z "$PS1" ]; then
  # NOTE: this is required so that if i run fzf from app like
  # kitty -e "cat <something> |fzf", the colors match the theme

  export SYSTEM_THEME=$(cat ~/.system-theme)
  file="$HOME/.config/fzf/themes/$SYSTEM_THEME.bash"
  if [ -e "$file" ]; then
    source $file
  fi
  return
fi

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
  if [ -e "$file" ]; then
    source "$file"
  else
    test "$BASHRC_DEBUG" && echo "[bashrc.DEBUG] failed to source file: $file"
  fi
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

if has_command claude; then
  alias code-agent="claude --dangerously-skip-permissions"
fi

alias gs='git status'
alias gss='git status -s'

alias vi='nvim'
alias vim='nvim'
alias k='kubectl'
alias k9s='k9s --logoless --headless -c ns'

has_command bat && alias cat='bat'

alias shell_reload='source ~/.bashrc'

# -------------------
# Section: Env Vars
# -------------------

# export EDITOR=nvim
# export PAGER="nvim -R"
export MANPAGER='nvim +Man!'

# XDG Dirs
# export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_CACHE_HOME="$HOME/.cache"
# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_STATE_HOME="$HOME/.local/state"
#
# export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
# export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
# export NPM_CONFIG_STORE_DIR="$XDG_DATA_HOME/node/bin"
# export GOPATH="$XDG_DATA_HOME/go"

# export NIX_CONFIG="experimental-features = nix-command flakes"
#
# export NIXY_EXECUTOR="bubblewrap"
# export NIXY_USE_PROFILE="true"

[ -e ~/.system-theme ] && export SYSTEM_THEME=$(cat ~/.system-theme)
[ -z "$SYSTEM_THEME" ] && export SYSTEM_THEME=dark

function add_to_path() {
  for item in "$@"; do
    [ -d "$item" ] || continue

    case ":$PATH:" in
    *":$item:"*) ;; # already in PATH, do nothing
    *) PATH="$item:$PATH" ;;
    esac
  done
  export PATH
}

#
# ## zoxide exclude DIRS
# export _ZO_EXCLUDE_DIRS=".secrets:archived:.dump:old"
#
# export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --smart-case"
#
# # to make GPG work with TTY input box
# export GPG_TTY=$(tty)

# add_to_path_if_exists "$HOME/workspace/nxtcoder17/jeera-rice/bin"
# add_to_path_if_exists "$HOME/.local/jeera-rice-bin"
#
# add_to_path_if_exists "$HOME/.local/bin"
# add_to_path_if_exists "$GOPATH/bin"
# add_to_path_if_exists "$HOME/workspace/github.com/kloudlite/internal-tools/bin"
# add_to_path_if_exists "$XDG_DATA_HOME/node/bin"
# add_to_path_if_exists "$XDG_DATA_HOME/bun/bin"
# add_to_path_if_exists "$HOME/.cache/.bun/bin"
# add_to_path_if_exists "$XDG_DATA_HOME/pnpm"

[ "$(uname)" = "Darwin" ] && append_to_path "/opt/homebrew/bin"

export NIXY_EXECUTOR="bubblewrap"
export NIXY_USE_PROFILE="true"

# direnv hook fish  | source 2>&1 > /dev/null

# -------------------
# Section: Custom Functions
# -------------------

function cc() {
  case "$(uname)" in
  Darwin)
    pbcopy
    return
    ;;
  Linux)
    [ "$XDG_BACKEND" = "wayland" ] && wl-copy && return
    xclip -sel clip
    return
    ;;
  esac
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

has_command fzf && source <(fzf --bash)
has_command zoxide && source <(zoxide init bash)
has_command nix && source_if_exists "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"

if has_command home-manager; then
  source_if_exists "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

  alias hm='home-manager'
  alias hme='home-manager edit'
  alias hms='home-manager switch'
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

  [ -n "$dirty" ] && dirty=" $dirty"

  echo "${YELLOW}($branch$dirty)${RESET}"
}

function __prompt() {
  # Colors
  local BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE DIM_CYAN RESET

  BLACK="\[\033[0;30m\]"
  RED="\[\033[0;31m\]"
  GREEN="\[\033[0;32m\]"
  YELLOW="\[\033[0;33m\]"
  BLUE="\[\033[0;34m\]"
  MAGENTA="\[\033[0;35m\]"
  CYAN="\[\033[0;36m\]"
  WHITE="\[\033[0;37m\]"

  DIM_CYAN="\[\033[2;36m\]"

  RESET="\[\033[0m\]"

  prompt_char="ϟ"
  prompt_char="${GREEN}$prompt_char${RESET}"

  if [ -n "$NIXY_SHELL" ]; then
    PS1="$NIXY_PROMPT_PREFIX"
    PS1+=" ${BLUE}$(echo $PWD | sed "s|$NIXY_WORKSPACE_DIR|$(basename $NIXY_WORKSPACE_DIR)|")${RESET}"
  else
    PS1="${BLUE}\w${RESET}"
  fi

  [ -n "$KUBECONFIG" ] && PS1+=" (  $(basename $KUBECONFIG))"

  source_if_exists "$HOME/.config/fzf/themes/$SYSTEM_THEME.bash"
  source_if_exists "$HOME/.config/ls/themes/$SYSTEM_THEME.bash"

  PS1="$PS1 $(__fast_git_info)
$prompt_char "
}

function __debug_performance() {
  local start end elapsed_ms
  start=$(date +%s.%N) # seconds.nanoseconds
  "${@}"
  end=$(date +%s.%N) # seconds.nanoseconds
  elapsed_ms=$(echo "($end - $start) * 1000" | bc)
  echo "$1 took: $elapsed_ms ms"
}

function __run_on_prompt_render() {
  # INFO: to debug performance issue of a function prefix it with __debug_performance
  __prompt
}

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
bind "set menu-complete-display-prefix on"

# shell completion
source_if_exists "/usr/share/bash-completion/bash-completion"
source_if_exists "${BASH_COMPLETION_DIR}/etc/profile.d/bash_completion.sh"

PROMPT_COMMAND="__run_on_prompt_render${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
if has_command nixy; then
  source <(nixy shell:hook bash)
fi

export _JAVA_OPTIONS="-Dawt.toolkit.name=WLToolkit -Dsun.java2d.uiScale.enabled=true"

export ANDROID_HOME="$HOME/Android"
add_to_path "$HOME/SDKs/flutter/bin"

## Only run fish for interactive sessions
# case "$-" in
# *i*)
#   if [[ -n "$BASH_EXECUTION_STRING" ]]; then
#     return
#   fi
#
#   # let prompt hook handle this
#   # [ "$NO_AUTO_EXEC_FISH" = "true" ] && [ -e "$PWD/nixy.yml" ] && unset NO_AUTO_EXEC_FISH && return
#
#   if has_command fish; then
#     exec fish
#   fi
#   ;;
# esac
