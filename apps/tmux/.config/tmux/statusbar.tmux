# vim: set ft=bash:

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
set-window-option -gF clock-mode-colour "$thm_sky"
set-window-option -g clock-mode-style 24

# pane
set-window-option -gF pane-active-border-style fg="$thm_sapphire",bold
set-window-option -gF pane-border-style fg="$thm_surface_2"
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
set -g @tmux-pop-color "$thm_surface_0"

# status-bar
set -g window-status-format "#[fg=$thm_bg,bg=default]$icon_window_left#[fg=$thm_subtext_1,bg=$thm_surface_1] #I#[fg=$thm_surface_1,bg=default]$icon_num_separator#[fg=$thm_overlay_2,bg=default] #W #{?pane_synchornized,$synchronized_icon, #F} #[fg=$thm_fg]$icon_window_right"

set -g window-status-current-format "#[fg=$thm_bg,bg=default]$icon_window_left#[bold]#[fg=$thm_bg,bg=$thm_sapphire] #I#[fg=$thm_sapphire,bg=default]$icon_num_separator #W #{?pane_synchronized,$synchronized_icon,#F} #[fg=$thm_fg]$icon_window_right"

set -g status-left ' 🌳 '

# set -g status-right "#{prefix_highlight} #[fg=$thm_bg]$icon_hostname_left#[fg=$thm_mauve,bg=$thm_bg]   #S (#H) #[fg=$thm_bg,bg=default,nobold,noitalics,nounderscore]$icon_hostname_right#[bg=default] "

set -g status-right "#{prefix_highlight} #[fg=$thm_sky,bg=default]   #S "

# plugin: prefix-hightlight
set -g @prefix_highlight_output_prefix "#[fg=$thm_bg]#[bg=default]#[nobold]#[noitalics]$icon_hostname_left#[fg=$thm_sapphire]#[bg=$thm_bg]"

set -g @prefix_highlight_output_suffix "#[fg=$thm_bg]#[bg=default]#[nobold]#[noitalics]#[nounderscore]$icon_hostname_right"

set -g @prefix_highlight_copy_mode_attr "fg=$thm_sapphire,bg=black,italics"
