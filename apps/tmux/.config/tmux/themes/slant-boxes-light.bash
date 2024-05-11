colorPrimary="#cbdbc5"
colorSecondary="#e1e5eb"
colorPrimaryText="#4c5c47"
colorSecondaryText="#4c5c47"

colorBackground="$colorSecondary"

colorWhite="#ffffff"
colorBlack="#000000"

colorBorder="#698e91"

# clock mode
set-window-option -g clock-mode-colour $colorPrimary
set-window-option -g clock-mode-style 24

# pane
set-window-option -g pane-active-border-style fg=$colorBorder,bold
set-window-option -g pane-border-style fg=$colorSecondary

# plugin: tmux-pop-color
set -g @tmux-pop-color white

# status-bar
set -g window-status-format "#[fg=$colorSecondary,bold,bg=default]#[fg=$colorPrimaryText,bold,bg=$colorSecondary] #I #[fg=$colorSecondaryText,bg=$colorSecondary,bold,noitalics,nounderscore] #W #F #[fg=$colorSecondary,bg=default]"

set -g window-status-current-format "#[fg=$colorBackground,bg=$colorPrimary,nobold,noitalics,nounderscore] #[fg=$colorPrimaryText,bold,bg=$colorPrimary]#I #[nobold,noitalics,nounderscore] #[bold]#W #F #[fg=$colorPrimary,bg=$colorBackground,nobold,noitalics,nounderscore]"

set -g status-right "#{prefix_highlight} #[fg=$colorPrimary,bg=default]#[fg=$colorSecondaryText,bg=$colorPrimary,bold] #S (#H) #[fg=$colorPrimary]#[bg=default]#[nobold]#[noitalics]#[nounderscore] #{pomodoro_status}"

# plugin: prefix-hightlight
set -g @prefix_highlight_output_prefix "#[fg=$colorPrimary]#[bg=default]#[nobold]#[noitalics]#[bg=$colorPrimary]#[fg=#3b3952]"

set -g @prefix_highlight_output_suffix "#[fg=$colorPrimary]#[bg=default]#[nobold]#[noitalics]#[nounderscore]"

set -g @prefix_highlight_copy_mode_attr "fg=$colorPrimary,bg=black,italics"
