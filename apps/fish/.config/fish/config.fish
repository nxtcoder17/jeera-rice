set -U fish_greeting

if type -q exa
  alias ls 'exa --icons'
  alias ll 'exa -la --icons'
end

# alias sudo "sudo -E env"
alias vim 'TERM=xterm-kitty nvim'
# alias nvim 'TERM=xterm-kitty nvim'
# function sudo 
#   command sudo -E=env $argv
# end

if ! test command -v nix &> /dev/null
  set nix_daemon_file "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish"
 if test -f "$nix_daemon_file" 
   source "$nix_daemon_file"
 end
end

# git abbreviations
abbr gs 'git status'
abbr gss 'git status -s'
abbr gsw 'git pull && git switch'
abbr nv 'nvim'

alias vi 'nvim'
alias vim 'nvim'
alias k 'kubectl'
alias k9s 'k9s --logoless --headless -c ns'
alias cat 'bat'
alias cursor 'cursor --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --ozone-platform-hint=auto'

function cc --description "copies stdout to system clipboard"
  if test "$(uname)" = "Darwin"
    pbcopy
    return
  end
  if test "$XDG_BACKEND" = "wayland"
    wl-copy
    return
  end
  xclip -sel clip
end

alias rm 'rm -i'

alias hm 'home-manager'
alias hme 'home-manager edit'
alias hms 'home-manager switch'

alias reload_fish "source ~/.config/fish/config.fish"

function sudo  --description "wraps sudo but tries to preserve PATH, as nix installed binaries are not in SUDO user PATH"
  # echo "path: $PATH"
  command sudo -E env "PATH=$PATH" $argv
end

## i don't want any right prompt
function fish_right_prompt
end

### fish bindings
set __fish_git_prompt_char_cleanstate ''
set __fish_git_prompt_char_dirtystate '  '
set __fish_git_prompt_char_invalidstate '  '
set __fish_git_prompt_char_stagedstate '  '
set __fish_git_prompt_char_stashstate '  '
set __fish_git_prompt_char_stateseparator ''
set __fish_git_prompt_char_untrackedfiles '  '
set __fish_git_prompt_char_upstream_ahead ''
set __fish_git_prompt_char_upstream_behind ''
set __fish_git_prompt_char_upstream_diverged ''
set __fish_git_prompt_char_upstream_equal ''
# set __fish_git_prompt_char_upstream_prefix ' '

set -g fish_prompt_pwd_full_dirs 3

# colors
set -g __color_dir "#2fbaf5"
set -g __color_git "#58bf9c"
set -g __color_kubeconfig "#2fbaf5"
set -g __color_nix "#2fbaf5"

set -g __icon_nix " "
set -g __icon_sep "|"

function fish_prompt
  [ -f ~/.colorscheme.d/fish/catppuccin.fish ] && source ~/.colorscheme.d/fish/catppuccin.fish
  [ -f ~/.colorscheme.d/fzf/catppuccin.fish ] && source ~/.colorscheme.d/fzf/catppuccin.fish

  # set prompt_char "😎"
  set prompt_char "ϟ" # Greek Small Letter Koppa[1]
  # set prompt_char "𝛌"
  [ ! -z "$fish_private_mode" ] && set prompt_char "🥷"
  [ "$EUID" -eq 0 ] && set prompt_char "√π"
  [ -n "$IN_NIX_SHELL" ] && set prompt_char " " && set prompt_color $__color_nix
  [ -n "$IN_NIXY_SHELL" ] && set prompt_char "[NIXY]" && set prompt_color $__color_nix

  if [ -n "$KUBECONFIG" ]
    printf "%s(󰠳 %s)%s " (set_color $__color_kubeconfig) (basename $KUBECONFIG) (set_color $fish_color_normal)
  end

  printf "%s%s" (set_color $fish_color_cwd) (prompt_pwd)
  printf "%s%s" (set_color $fish_color_command) (fish_git_prompt)
  printf "%s\n" (set_color $fish_color_normal)

  printf "$prompt_char "
end

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

  bind -M insert \cf forward-char
end

if status is-interactive
  # Commands to run in interactive sessions can go here
  # constant Environments
  set fish_cursor_default block
  set fish_cursor_insert line
  set fish_cursor_replace_one underscore
  set fish_cursor_visual block

  fish_vi_key_bindings

  function fish_mode_prompt
    # NOOP - Disable vim mode indicator
  end
end

function ck --description "choose-kubeconfig"
  set dir $HOME/.kube/configs
  set chosen_kubeconfig (command ls ~/.kube/configs | fzf --reverse --prompt "choose kubeconfig > ")

  if [ -z "$chosen_kubeconfig" ]
    set -e KUBECONFIG
    return
  end
  set -gx KUBECONFIG ~/.kube/configs/$chosen_kubeconfig
end

zoxide init fish | source

# # base16 manager
# [ -f ~/.base16.d/fish/base16.fish ] && source ~/.base16.d/fish/base16.fish
# [ -f ~/.base16.d/fzf/base16.fish ] && source ~/.base16.d/fzf/base16.fish
#
# [ -f ~/.base16/fish.fish ] && source ~/.base16/fish.fish
# [ -f ~/.base16/fzf.fish ] && source ~/.base16/fzf.fish

set -gx SHELL $(which fish)
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -gx NPM_CONFIG_STORE_DIR "$XDG_DATA_HOME/node/bin"

## zoxide exclude DIRS
set -gx _ZO_EXCLUDE_DIRS "$HOME:$HOME/workspace/kloudlite/archived/.*"

set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --smart-case"
set -gx GPG_TTY (tty) # to make GPG work with TTY input box

set -x LANGUAGE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
set -x LANG "en_US.UTF-8"
set -x LC_TYPE "en_US.UTF-8"
set -x MANPAGER 'nvim +Man!'

set -gx DIRENV_LOG_FORMAT ""
set -gx EDITOR nvim
set -gx PAGER less

# xdg path
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx GOPATH "$XDG_DATA_HOME/go"

set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -gx NPM_CONFIG_TMP "$XDG_RUNTIME_DIR/npm"
set -gx NPM_CONFIG_STORE_DIR "$XDG_DATA_HOME/node/bin"

fish_add_path "$HOME/me/jeera-rice/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$GOPATH/bin"
fish_add_path $HOME/workspace/github.com/kloudlite/internal-tools/bin
fish_add_path "$XDG_DATA_HOME/node/bin"
fish_add_path "$XDG_DATA_HOME/bun/bin"
fish_add_path "$XDG_DATA_HOME/pnpm/bin"
if test "$(uname)" = "Darwin"
  fish_add_path "/opt/homebrew/bin"
end

# direnv hook fish  | source 2>&1 > /dev/null
