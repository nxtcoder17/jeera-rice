#! /usr/bin/env sh

# space key as Left Shift
xmodmap -e 'keycode 65 = Shift_L'

# make space toggle b/w space and Shift_L
xcape -e 'Shift_L=space'
