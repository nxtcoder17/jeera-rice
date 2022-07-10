setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

PROMPT_EOL_MARK=""        # hide EOL sign ('%')
stty stop undef           # No Ctrl-s to freeze the terminal

# enable completion features
autoload -U compinit && compinit

zmodload zsh/complist
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
_comp_options+=(globdots)		# Include hidden files.

# History in XDG Cache
HISTSIZE=100000
SAVEHIST=100000

[ -d $HOME/.cache/zsh ] || mkdir -p $HOME/.cache/zsh

HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

setopt append_history
setopt inc_append_history
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_save_no_dups      # duplicate commands are not written
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
# setopt share_history          # share command history data
setopt hist_reduce_blanks     # removing blank lines from the history

# vi mode
bindkey -v
export KEYTIMEOUT=1
autoload -U colors && colors

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# ci{, ci(, di{ etc..  
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'};
  do
    bindkey -M $m $c select-bracketed
  done
done

zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}

zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

bindkey -s '^a' 'bc -lq\n'

# Override's fzf bindings
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

export zshDir=$XDG_CONFIG_HOME/zsh

# Aliases
# [ -f "$ZDOTDIR/alias" ] && source "$ZDOTDIR/alias"
[ -f "$zshDir/alias" ] && source "$zshDir/alias"

# Functions
[ -f "$zshDir/functions" ] && source "$zshDir/functions"

export BUILD_LIBRDKAFKA=0

[ -f $HOME/.secrets ] && source ~/.secrets

# Dracula Themed
# export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

fzf_completion_file="/usr/share/fzf/completion.zsh"
fzf_keybindings_file="/usr/share/fzf/key-bindings.zsh"
[ -f $fzf_completion_file ] && source $fzf_completion_file
[ -f $fzf_keybindings_file ] && source $fzf_keybindings_file

[ -f $zshDir/git-flow-completion.zsh ] && source $zshDir/git-flow-completion.zsh

export LESS=-FRX

# source .nxtcoder17.sh file, if it sees it anywhere
# this makes system hackable

[ -f $HOME/.env ] && source $HOME/.env

# wait till we find a good alternative
# [ -f $PWD/.nxtcoder17.sh ] && source .nxtcoder17.sh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

[ -f $PWD/.auto.env ] && source $PWD/.auto.env
[ $EUID -eq 0 ] && source $ZDOTDIR/.zprofile

# Load syntax highlighting; should be last.
# source /home/nxtcoder17/.local/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

# export LUA_PATH='/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua;/usr/lib/lua/5.4/?.lua;/usr/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua;/home/nxtcoder17/.luarocks/share/lua/5.4/?.lua;/home/nxtcoder17/.luarocks/share/lua/5.4/?/init.lua'
# export LUA_CPATH='/usr/lib/lua/5.4/?.so;/usr/lib/lua/5.4/loadall.so;./?.so;/home/nxtcoder17/.luarocks/lib/lua/5.4/?.so'
# export PATH='/home/nxtcoder17/.luarocks/bin:/home/nxtcoder17/apps/jeera-rice/bin:/home/nxtcoder17/.local/share/go/bin:/home/nxtcoder17/.local/share/node/bin:/opt/google-cloud-sdk/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl'

# bun completions
[ -s "/home/nxtcoder17/.bun/_bun" ] && source "/home/nxtcoder17/.bun/_bun"
