set fish_greeting

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
abbr nv 'nvim'

alias k 'kubectl'
alias k9s 'k9s --logoless --headless -c ns'
alias cc 'xclip -sel clip'
alias ls 'exa --icons -FG'
alias rm 'rm -i'
alias task 'go-task'

alias hm 'home-manager'
alias hme 'home-manager edit'
alias hms 'home-manager switch'

if type -q kubie
    alias kx 'kubie ctx'
end

if [ -f "$__fish_config_dir/nxtfns.fish" ]
    source "$__fish_config_dir/nxtfns.fish"
end

# if [ -f "$__fish_config_dir/themes/kanagawa.fish" ]
#     source "$__fish_config_dir/themes/kanagawa.fish"
# end

function addToPath --description "add item to system path"
    for item in $argv
        contains $item $PATH 
        or set -x PATH $item $PATH 
    end
end

function fish_right_prompt
 #intentionally left blank
end

# echo "snippet inspired from kubie"
function ck --description "choose-kubeconfig"
  set dir $HOME/.kube/configs

  # need to do command grouping for chaining 2 separate commands into one redirection
  # read here https://unix.stackexchange.com/questions/223835/capturing-output-redirection-of-commands-chained-by
  set filter_cmd 'begin; echo "no-selection" && command ls ~/.kube/configs ; end | fzf'

  set -gx TMP_KUBECONFIG_FILE (eval $filter_cmd)


  set -gx is_valid_kubeconfig "true"

  if [ -z "$TMP_KUBECONFIG_FILE" -o "$TMP_KUBECONFIG_FILE" = "no-selection" ]
    set -gx is_valid_kubeconfig ""
  end

  # [ -z "$TMP_KUBECONFIG_FILE" ] && set -gx is_valid_kubeconfig ""
  # [ "$TMP_KUBECONFIG_FILE" = "no-selection" ] && set -gx is_valid_kubeconfig ""

  if [ -n "$is_valid_kubeconfig" ]
    set -gx KUBECONFIG "$dir/$TMP_KUBECONFIG_FILE"
  else
    set -e KUBECONFIG
  end

  if ! functions -q fish_prompt_original
    functions -c fish_prompt fish_prompt_original
  end
  # functions --copy fish_prompt fish_prompt_original
  function fish_prompt
    set -l original (fish_prompt_original)

    # printf '%s ' (string unescape {prompt})
    if [ -n "$is_valid_kubeconfig" ]
      printf '%s󱃾 %s%s ' (set_color "#5582a1") $TMP_KUBECONFIG_FILE $hydro_color_normal
    end

    # Due to idiosyncrasies with the way fish is managing newlines in
    # process substitions, each line needs to be printed separately
    # to mirror the existing output. For more details,
    # see https://github.com/fish-shell/fish-shell/issues/159.
    for line in $original
        echo -e $line
    end
  end
end

set -gx EDITOR nvim
set -gx PAGER less
set -gx EMAIL "nxtcoder17@gmail.com"
set -gx BROWSER "firefox"

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

# set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --smart-case"

set -gx GPG_TTY (tty) # to make GPG work

#--------------------------------------------------
addToPath /usr/local/bin
addToPath $HOME/.local/bin $HOME/me/jeera-rice/bin $HOME/workspace/.local/share/node/.bin

# node js global install packages
addToPath $XDG_DATA_HOME/node/bin

# go install binaries
addToPath $XDG_DATA_HOME/go/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
    # constant Environments
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
set --global hydro_color_git "#71bd80"
set --global hydro_color_prompt "#3a73d6"
set --global hydro_color_pwd "#2fbaf5"

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

if [ $EUID -eq 0 ]
    # set --global hydro_symbol_prompt ❱
    # set --global hydro_symbol_prompt 🚫√ √ 
    # set --global hydro_color_prompt "#ff0203"
    set --global hydro_color_prompt "#bf4b52"
    # set --global hydro_symbol_prompt '∖/‾‾‾'
    set --global hydro_symbol_prompt ' √π'
else
    # set --global hydro_symbol_prompt ❱
    set --global hydro_symbol_prompt 😎
    # check if fish is in private mode 
    if [ ! -z "$fish_private_mode" ]
      set --global hydro_symbol_prompt 🕵️
    end
end

set -x LANGUAGE "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
set -x LANG "en_US.UTF-8"
set -x LC_TYPE "en_US.UTF-8"


set -x LUA_PATH "$HOME/.nix-profile/lib/lua/5.4/lpeg.so;;"
set -x LUA_CPATH "$HOME/.nix-profile/lib/lua/5.4/lpeg.so;;"
# set -x LUA_PATH "$HOME/.nix-profile/lib/lua/5.4/*;;"
# set -x LUA_CPATH "$HOME/.nix-profile/lib/lua/5.4/*;;"

zoxide init fish | source
# starship init fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

if [ -f "$__fish_config_dir/themes/tokyo-night-moon.fish" ]
    source "$__fish_config_dir/themes/tokyo-night-moon.fish"
end

# if [ -f "$__fish_config_dir/themes/tokyonight-day.fish" ]
#     source "$__fish_config_dir/themes/tokyonight-day.fish"
# end

echo "$PATH" > "/tmp/$USER-paths"
