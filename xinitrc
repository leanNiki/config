#!/bin/sh

# load env variables
[ -f "$HOME/.config/env" ] && source "$HOME/.config/env"

# xresources
xrdb -merge ~/.config/xresources-light

# set capslock to escape
setxkbmap de -option caps:escape

# increase key-repeat initialization + speed
xset r rate 220 45

# set wallpaper
feh  --bg-scale "$HOME/.config/wallpaper-light" --no-fehbg

# start music player daemon (if no other user instance exists)
[ ! -s $HOME/.config/mpd/pid ] && mpd

# bluetooth manager systray icon
exec blueman-applet &
exec nm-applet &

exec qtile
