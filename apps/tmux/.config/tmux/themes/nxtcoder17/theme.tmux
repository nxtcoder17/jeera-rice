source ~/.base16.d/tmux/base16.sh

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

# synchronized_icon='📎'
synchronized_icon='󱉣'

# clock mode
set-window-option -g clock-mode-colour "$hl_selected_bg"
set-window-option -g clock-mode-style 24

# pane
set-window-option -g pane-active-border-style fg="$hl_selected_fg",bold
set-window-option -g pane-border-style fg="$hl_fg"
# set -g pane-border-status off

set-window-option -g pane-border-lines "simple"
set -g pane-border-status off #top
set pane-border-format "[#{pane_current_command} (#{pane_current_path})]"
# tmux set pane-border-format '#[fg=brightwhite#, bg=darkgreen] #W [#{pane_index}] → #{pane_title} '
# set -g pane-border-format '#{?pane_in_mode,} #W [#{pane_index}] → #{pane_title} '

# tmux set-option -gw pane-active-border-style "#{?pane_in_mode,fg=yellow,#{?synchronize-panes,fg=red,#{?pane_input_off,fg=colour17,fg=green}}}"

# plugin: tmux-pop-color
set -g @tmux-pop-color black

# status-bar
set -g window-status-format "#[fg=$hl_bg,bg=default]$icon_window_left#[fg=$hl_fg,bg=$hl_bg] #I#[fg=$hl_bg,bg=default]$icon_num_separator#[fg=$hl_fg,bg=default] #W #{?pane_synchornized,$synchronized_icon, #F} #[fg=$hl_fg]$icon_window_right"

set -g window-status-current-format "#[fg=$hl_bg,bg=default]$icon_window_left#[bold]#[fg=$hl_selected_fg,bg=$hl_selected_bg] #I#[fg=$hl_selected_bg,bg=default]$icon_num_separator#[fg=$hl_selected_fg,bg=default] #W #{?pane_synchronized,$synchronized_icon,#F} #[fg=$hl_fg]$icon_window_right"

set -g status-left ' 🌳 '

set -g status-right "#{prefix_highlight} #[fg=$hl_selected_fg,bg=default]   #S #[fg=$hl_selected_bg,bg=default,nobold,noitalics,nounderscore]#[bg=default] "

# plugin: prefix-hightlight
set -g @prefix_highlight_output_prefix "#[fg=$hl_selected_bg]#[bg=default]#[nobold]#[noitalics]$icon_hostname_left#[fg=$hl_selected_fg]#[bg=$hl_bg]"

set -g @prefix_highlight_output_suffix "#[fg=$hl_bg]#[bg=default]#[nobold]#[noitalics]#[nounderscore]$icon_hostname_right"

set -g @prefix_highlight_copy_mode_attr "fg=$hl_selected_bg,bg=black,italics"
