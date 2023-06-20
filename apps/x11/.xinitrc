xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

# Starting gnome keyring daemon
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# libinput-gestures-setup start

# X Resources
xrdb -merge ~/.Xresources
xrdb -load ~/.Xresources

# export PATH="$HOME/.cargo/bin:$PATH"

keyboard-defaults.sh

redshift -O 3000

touchpadName=$(xinput list --name-only | grep -i 'touchpad')
xinput set-prop "$touchpadName" 'libinput Tapping Enabled' 1

# export PATH="/home/nxtcoder17/workspace/nxtcoder17/forks/i3/build:$PATH"
exec i3 &>> "/tmp/i3.log"
