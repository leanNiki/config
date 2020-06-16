#!/bin/sh


# load env variables
[ -f "$HOME/.config/env" ] && source "$HOME/.config/env"

# fix video outputs
#xrandr --setprovideroutputsource modesetting NVIDIA-0
#xrandr --auto
#xrandr --dpi 96

# source files in xinitrc.d folder
#if [ -d /etc/X11/xinit/xinitrc.d ] ; then
# for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
#  [ -x "$f" ] && . "$f"
# done
# unset f
#fi

# xresources
xrdb -merge ~/.config/xresources

# set capslock to escape
setxkbmap de -option caps:escape

# increase key-repeat initialization + speed
xset r rate 220 45

# set wallpaper
feh  --bg-scale "$HOME/.config/wallpaper-light" --no-fehbg

# start music player daemon (if no other user instance exists)
[ ! -s $HOME/.config/mpd/pid ] && mpd

# load nvm/node
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# bluetooth manager systray icon
exec blueman-applet &

exec qtile
