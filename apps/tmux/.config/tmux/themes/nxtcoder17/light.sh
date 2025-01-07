# vim: set ft=tmux:

# hl_bg="#ddeff0"
hl_bg="#ccdadb"
hl_fg="#72898f"
hl_selected_bg="#2e788c"
hl_selected_fg="#314142"

# [glymphs](https://www.compart.com/en/unicode/category/So)
# ░ \u2591 ░ \u2592 ▓ \u2593

# icon_window_left="▒▓"
# icon_window_left=""
icon_window_left=""
icon_window_right=""

# icon_num_separator=""
icon_num_separator=""

icon_hostname_left=""
icon_hostname_right=""

synchronized_icon='󱉣'

# clock mode
set-window-option -g clock-mode-colour "$hl_selected_bg"
set-window-option -g clock-mode-style 24

# pane
set-window-option -g pane-active-border-style fg="$hl_selected_bg",bold
set-window-option -g pane-border-style fg="$hl_bg"
set-window-option -g pane-border-lines "heavy"

# plugin: tmux-pop-color
set -g @tmux-pop-color white

# pane status-bar settings
set -g pane-border-format "[#[fg=$hl_selected_bg] #{pane_current_command} #[fg=default]]"
set -g pane-border-status top
set-window-option -g pane-border-lines "simple"
# set pane-border-format "[ #[fg=#{?pane_in_mode,$hl_fg,$hl_selected_bg}] #{pane_current_command} ]"

# status-bar
set -g window-status-format "#[fg=$hl_bg,bold,bg=default]$icon_window_left#[fg=$hl_fg,bold,bg=$hl_bg] #I#[fg=$hl_bg,bg=default]$icon_num_separator#[fg=$hl_fg,bold,bg=default] #W #{?pane_synchornized,$synchronized_icon, #F} #[fg=$hl_fg]$icon_window_right"

set -g window-status-current-format "#[fg=$hl_bg,bold,bg=default]$icon_window_left#[fg=$hl_bg,bold,bg=$hl_selected_bg] #I#[fg=$hl_selected_bg,bg=default]$icon_num_separator#[fg=$hl_selected_fg,bold] #W #{?pane_synchronized,$synchronized_icon,#F} #[fg=$hl_fg]$icon_window_right "

set -g status-left ' 🌳 '

set -g status-right "#{prefix_highlight} #[fg=$hl_bg]$icon_hostname_left#[fg=$hl_selected_fg,bg=$hl_bg,bold]   #S (#H) #[fg=$hl_bg,bg=default,nobold,noitalics,nounderscore]$icon_hostname_right#[bg=default] "

# plugin: prefix-hightlight
set -g @prefix_highlight_output_prefix "#[fg=$hl_bg]#[bg=default]#[nobold]#[noitalics]$icon_hostname_left#[fg=$hl_fg]#[bg=$hl_bg]"

set -g @prefix_highlight_output_suffix "#[fg=$hl_bg]#[bg=default]#[nobold]#[noitalics]#[nounderscore]$icon_hostname_right"

set -g @prefix_highlight_copy_mode_attr "fg=$hl_selected_bg,bg=black,italics"
