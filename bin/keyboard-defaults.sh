#! /usr/bin/env sh

xset r rate 160 80

setxkbmap -option ctrl:nocaps

# left shift as space
xmodmap -e 'keycode 50 = space'

# space key as Left Shift
xmodmap -e 'keycode 65 = Shift_L'

pkill -9  xcape

# make space toggle b/w space and Shift_L
xcape -e 'Shift_L=space'

xcape -e 'Control_L=Escape'
