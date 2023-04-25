#! /usr/bin/env sh

# xset r rate 140 75
xset r rate 160 80
# xset r rate 200 100
setxkbmap -option ctrl:nocaps

# left shift as space
xmodmap -e 'keycode 50 = space'

# space key as Left Shift
xmodmap -e 'keycode 65 = Shift_L'

xmodmap -e "keycode 133    = Alt_L Meta_L"
xmodmap -e "keycode 64     = Super_L"
xmodmap -e "clear Mod1"
xmodmap -e "clear Mod4"
xmodmap -e "add    Mod1    = Alt_L 0x007D"
xmodmap -e "add    Mod4    = Super_L Super_R"

pkill -9 xcape

# make space toggle b/w space and Shift_L
xcape -e 'Shift_L=space'
xcape -e 'Control_L=Escape'
