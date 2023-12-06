# Nightfox Color Palette
# Style: nightfox
# Upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/nightfox/nightfox_fish.fish
set -l foreground cdcecf #cdcecf
set -l selection 2b3b51 #2b3b51
set -l comment 738091 #738091
# set -l blue 61aef2 #61aef2
set -l blue 29b8ff #29b8ff
set -l red c94f6d #c94f6d
set -l orange f4a261 #f4a261
set -l yellow dbc074 #dbc074
set -l green 81b29a #81b29a
set -l purple 9d79d6 #9d79d6
set -l cyan 63cdcf #63cdcf
set -l pink d67ad2 #d67ad2

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
