# vim: set ft=bash:

# [glymphs](https://www.compart.com/en/unicode/category/So)
# ░ \u2591 ░ \u2592 ▓ \u2593

# icon_window_left="▒▓"
# icon_window_left=""
icon_window_left=""
icon_window_right=""

# icon_num_separator=""
icon_num_separator=""
separator_left=""
separator_right=""

icon_hostname_left=""
icon_hostname_right=""

# synchronized_icon='📎'
synchronized_icon='󱉣'

# clock mode
set-window-option -gF clock-mode-colour "$thm_cyan"
set-window-option -g clock-mode-style 24

# pane
set-window-option -gF pane-active-border-style fg="$thm_cyan"
set-window-option -gF pane-border-style fg="$thm_bg_surface"
# set-window-option -g pane-border-lines "single"
set -g pane-border-status off

# set -g pane-border-status top
set-window-option -g pane-border-lines "simple"
# set pane-border-format "[ #[fg=#{?pane_in_mode,$thm_fg,$thm_mauve}] #{pane_current_command} ]"
# set pane-border-format "[#[fg=$thm_mauve] #{pane_current_command} #[fg=default]]"

# tmux set pane-border-format '#[fg=brightwhite#, bg=darkgreen] #W [#{pane_index}] → #{pane_title} '
# set -g pane-border-format '#{?pane_in_mode,} #W [#{pane_index}] → #{pane_title} '

# tmux set-option -gw pane-active-border-style "#{?pane_in_mode,fg=yellow,#{?synchronize-panes,fg=red,#{?pane_input_off,fg=colour17,fg=green}}}"

# plugin: tmux-pop-color
set -g @tmux-pop-color "$thm_bg_surface"

# status-bar
set -g window-status-format "#[fg=$thm_fg_muted,bg=default]$icon_window_left#[fg=$thm_bg,bg=$thm_fg_muted] #I#[fg=$thm_fg_muted,bg=default]$icon_num_separator#[fg=$thm_fg_muted,bg=default] #W #{?pane_synchronized,$synchronized_icon, #F} #[fg=$thm_fg]$icon_window_right"

set -g window-status-current-format "#[fg=$thm_fg,bg=default]$icon_window_left#[bold]#[fg=$thm_bg,bg=$thm_magenta] #I#[fg=$thm_magenta,bg=default]$icon_num_separator #[fg=$thm_magenta]#W #{?pane_synchronized,$synchronized_icon,#F} #[fg=$thm_fg]$icon_window_right"

set -g status-left ' 🌳 '

set -g mode-style "bg=$thm_magenta,fg=$thm_bg"

# set -g status-right "#{prefix_highlight} #[fg=$thm_bg]$icon_hostname_left#[fg=$thm_mauve,bg=$thm_bg]   #S (#H) #[fg=$thm_bg,bg=default,nobold,noitalics,nounderscore]$icon_hostname_right#[bg=default] "

set -g status-right "#{prefix_highlight} #[fg=$thm_magenta,bg=$thm_bg_surface,bold]   #S #[fg=$thm_bg_surface,bg=default]$separator_right"

# plugin: prefix-hightlight
set -g @prefix_highlight_output_prefix "#[fg=$thm_fg_muted]#[bg=default]#[nobold]#[noitalics]$icon_hostname_left#[fg=$thm_bg]#[bg=$thm_fg_muted]"

set -g @prefix_highlight_output_suffix "#[fg=$thm_fg_muted]#[bg=default]#[nobold]#[noitalics]#[nounderscore]$icon_hostname_right"

set -g @prefix_highlight_copy_mode_attr "fg=$thm_fg_muted,bg=black,italics"
