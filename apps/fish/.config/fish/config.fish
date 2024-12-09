set -U fish_greeting

function fish_mode_prompt
  # NOOP - Disable vim mode indicator
end

# if test (command -v exa | wc -l) -gt 0
if type -q exa
    alias ls 'exa --icons'
    alias ll 'exa -la --icons'
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

function cc --description "copies stdout to system clipboard"
  if test "$XDG_BACKEND" = "wayland"
    wl-copy
    return
  end
  xclip -sel clip
end

alias rm 'rm -i'
# alias task 'go-task'

alias hm 'home-manager'
alias hme 'home-manager edit'
alias hms 'home-manager switch'

alias reload_fish "source ~/.config/fish/config.fish"

set -x SYSTEM_THEME $(cat ~/.system-theme)

# function reload_fish_theme --on-variable SYSTEM_UI_THEME
function reload_fish_theme
  if [ "$SYSTEM_THEME" = "" ]
    set -gx SYSTEM_THEME $(cat ~/.system-theme)
  end

  # fish theme
  [ "$SYSTEM_THEME" = "dark" ] && source "$__fish_config_dir/themes/kanagawa.fish"
  [ "$SYSTEM_THEME" = "light" ] && source "$__fish_config_dir/themes/dayfox.fish"

  # theming for github.com/nxtcoder17/runfile
  set -gx RUNFILE_THEME $SYSTEM_THEME

  # FZF theme
  set -gx FZF_DEFAULT_OPTS '--border-label="" --preview-window="border-rounded" --prompt="> " --marker=">" --pointer="👉" --separator="─" --scrollbar="│"'

  [ "$SYSTEM_THEME" = "dark" ] && set -x FZF_DEFAULT_OPTS "\
    --color=bg+:#363a4f,spinner:#f4dbd6,hl:#ed8796 \
    --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
    --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796" $FZF_DEFAULT_OPTS

  [ "$SYSTEM_THEME" = "light" ] && set -x FZF_DEFAULT_OPTS '--color=fg:#252424,fg+:#211b1b,bg+:#f0f0f0 --color=hl:#2fb891,hl+:#1f9f7a,info:#afaf87,marker:#1f9f7a --color=prompt:#1f9f7a,spinner:#2e3993,pointer:#2e3993,header:#87afaf --color=gutter:#ffffff,border:#262626,label:#aeaeae,query:#2e3993' $FZF_DEFAULT_OPTS

  # bat theme
  set -gx BAT_STYLE "numbers"
  [ "$SYSTEM_THEME" = "dark" ] && set -gx BAT_THEME "OneHalfDark"
  [ "$SYSTEM_THEME" = "light" ] && set -gx BAT_THEME "gruvbox-light"
end

function sudo  --description "wraps sudo but tries to preserve PATH, as nix installed binaries are not in SUDO user PATH"
  # echo "path: $PATH"
  command sudo -E env "PATH=$PATH" $argv

  # set cmd $argv[1]
  # if [ -z "$cmd" ]
  #   command sudo -E PATH=$PATH $argv
  #   return
  # end
  #
  # if string match -- '-*' $cmd 2>&1 > /dev/null
  #   command sudo -E PATH=$PATH  $argv
  #   return
  # end
  #
  # # command sudo env $(which $cmd) $argv[2..-1]
  # command sudo -E PATH=$PATH $argv 
end

function direnv --description "direnv hook"
  echo "direnv hook loading ..."
  command direnv $argv 2>&1 > /dev/null
end

if [ -f "$__fish_config_dir/nxtfns.fish" ]
    source "$__fish_config_dir/nxtfns.fish"
end

function gdiff --description "git diff with FZF"
  set preview "git diff $argv --color=always -- {-1}"
  git diff $argv --name-only | fzf -m --ansi --preview $preview
end

function addToPath --description "add item to system path"
    for item in $argv
        contains $item $PATH
        or set -x PATH $item $PATH
    end
end

function fish_right_prompt
 #intentionally left blank
end

set -x fish_prompt_pwd_dir_length 20
set -x fish_prompt_pwd_full_dirs yes

function handle_nix_shell --description "checks if fish is running in a nix flake/shell"
  set nix_color "#8DAB35"
  [ "$SYSTEM_THEME" = "light" ] && set nix_color "#35ab8e"
  if [ -n "$IN_NIX_SHELL" ]
    printf "%sNIX%s " (set_color $nix_color) $hydro_color_normal
  end
end

if ! functions -q fish_prompt_original
  functions -c fish_prompt fish_prompt_original
end

function ck --description "choose-kubeconfig"
  set dir $HOME/.kube/configs

  # need to do command grouping for chaining 2 separate commands into one redirection
  # read here https://unix.stackexchange.com/questions/223835/capturing-output-redirection-of-commands-chained-by
  # set chosen_kubeconfig (begin; echo "no-selection" && command ls ~/.kube/configs ; end | fzf --reverse --prompt "choose kubeconfig > ")
  set chosen_kubeconfig (command ls ~/.kube/configs | fzf --reverse --prompt "choose kubeconfig > ")

  if [ -z "$chosen_kubeconfig" ]
    set -e KUBECONFIG
    return
  end
  set -gx KUBECONFIG ~/.kube/configs/$chosen_kubeconfig
end

set -g fish_prompt_pwd_full_dirs 5

function fish_prompt
  reload_fish_theme

  if [ $EUID -eq 0 ]
      set --global hydro_color_prompt "#bf4b52"
      set --global hydro_symbol_prompt ' √π'
  else
      # set --global hydro_symbol_prompt ❱
      set --global hydro_symbol_prompt "😎"
      if [ -n "$IN_NIX_SHELL" ]
        set --global hydro_color_prompt "#49ebc2"
        [ "$SYSTEM_THEME" = "light" ] && set --global hydro_color_prompt "#35ab8e"
        set --global hydro_symbol_prompt " "
      end

      # check if fish is in private mode
      if [ ! -z "$fish_private_mode" ]
        # set --global hydro_color_prompt "#e0da82"
        set --global hydro_symbol_prompt "🥷"
      end

      # check if fish is running in nix shell/flake environment
  end

  set -g __fish_git_prompt_showupstream auto

  set nix_color "#8DAB35"
  [ "$SYSTEM_THEME" = "light" ] && set nix_color "#35ab8e"
  if [ -n "$IN_NIX_SHELL" ]
    printf "%sNIX%s " (set_color $nix_color) $hydro_color_normal
  end

  if [ -n "$KUBECONFIG" ]
    set kubeconfig_color "#8DAB35"
    printf '%s󱃾 %s%s ' (set_color -o $kubeconfig_color) (basename $KUBECONFIG) $hydro_color_normal
  end

  set -g color_pwd "#2fbaf5"
  [ "$SYSTEM_THEME" = "light" ] && set -g color_pwd "#2F5BA2"
  if [ -n "$KL_SHELL" ]
    printf "%s(kl shell) %s" (set_color $color_pwd) (set_color $hydro_color_normal)
  end
  printf "%s%s%s %s\n" (set_color $color_pwd) (prompt_pwd) (set_color $hydro_color_normal) (fish_git_prompt)
  printf "%s%s " (set_color $hydro_color_prompt) $hydro_symbol_prompt
end

set -gx EDITOR nvim
set -gx PAGER less
set -gx EMAIL "nxtcoder17@gmail.com"
set -gx BROWSER "firefox"
set -gx DIRENV_LOG_FORMAT ""

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# set -gx XINITRC "$XDG_CONFIG_HOME/x11/xinitrc"
set -gx INPUTRC "$XDG_CONFIG_HOME/inputrc"

# APPLICATION specifics
set -gx SHELL $(which fish)
set -gx GOPATH "$XDG_DATA_HOME/go"
set -gx K9SCONFIG "$XDG_CONFIG_HOME/k9s"
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx _JAVA_OPTIONS "-DJava.util.prefs.userRoot=$XDG_CONFIG_HOME/java -Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on"

set -gx NODE_REPL_HISTORY "$XDG_DATA_HOME/node_repl_history"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -gx NPM_CONFIG_TMP "$XDG_RUNTIME_DIR/npm"
set -gx NPM_CONFIG_STORE_DIR "$XDG_DATA_HOME/node/bin"

set -gx XAUTHORITY "$HOME/.Xauthority"
set -gx _JAVA_AWT_WM_NONREPARENTING "1"

### zoxide exclude DIRS
set -gx _ZO_EXCLUDE_DIRS "$HOME:$HOME/workspace/kloudlite/archived/.*"

set -gx FZF_DEFAULT_COMMAND "rg --files --reverse --hidden --follow --smart-case"

set -gx GPG_TTY (tty) # to make GPG work with TTY input box

#--------------------------------------------------
addToPath /usr/local/bin
addToPath $HOME/me/jeera-rice/bin # jeera rice bin scripts
addToPath $HOME/.local/bin # local binaries

# only while development
addToPath "$HOME/workspace/github.com/kloudlite/internal-tools/bin"

addToPath $XDG_DATA_HOME/node/bin # nodejs global binaries
addToPath $XDG_DATA_HOME/bun/bin # bun binaries
addToPath $XDG_DATA_HOME/go/bin # go binaries

if status is-interactive
    # Commands to run in interactive sessions can go here
    # constant Environments
  set fish_cursor_default block
  set fish_cursor_insert line
  set fish_cursor_replace_one underscore
  set fish_cursor_visual block

  fish_vi_key_bindings
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
end

### fish bindings
set __fish_git_prompt_char_cleanstate '  '
set __fish_git_prompt_char_dirtystate '  '
set __fish_git_prompt_char_invalidstate '  '
set __fish_git_prompt_char_stagedstate '  '
set __fish_git_prompt_char_stashstate '  '
set __fish_git_prompt_char_stateseparator ' '
set __fish_git_prompt_char_untrackedfiles '  '
set __fish_git_prompt_char_upstream_ahead '  '
set __fish_git_prompt_char_upstream_behind '  '
set __fish_git_prompt_char_upstream_diverged '  '
set __fish_git_prompt_char_upstream_equal '  '
set __fish_git_prompt_char_upstream_prefix ' '

set --global hydro_multiline true
set git_color "#58bf9c"
[ "$SYSTEM_THEME" = "light" ] && set git_color "#047D54"
set --global hydro_color_git -o $git_color
set --global hydro_color_prompt "#3a73d6"

set -g color_pwd "#2fbaf5"
[ "$SYSTEM_THEME" = "light" ] && set -g color_pwd "#2F5BA2"
set --global hydro_color_pwd $color_pwd

set --global hydro_symbol_git_dirty	$__fish_git_prompt_char_dirtystate
set --global hydro_symbol_git_ahead $__fish_git_prompt_char_upstream_ahead
set --global hydro_symbol_git_behind $__fish_git_prompt_char_upstream_behind

# export LD_LIBRARY_PATH=/usr/local/boost_1_54_0/stage/lib:$LD_LIBRARY_PATH
#
function wgr --description "restarts wireguard"
    wg-quick down "$argv"
    wg-quick up "$argv"
end

function xfix --description "fixes x clipboard"
echo "
#!/sbin/bash
export XAUTHORITY=~/.Xauthority
" > /etc/profile.d/xauth.sh
end


set -x LANGUAGE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
set -x LANG "en_US.UTF-8"
set -x LC_TYPE "en_US.UTF-8"

zoxide init fish | source

# bun
set --export BUN_INSTALL "$XDG_DATA_HOME/bun"
set --export PATH $BUN_INSTALL/bin $PATH
