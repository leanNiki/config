#!/bin/sh
# this file gets loaded when startx is invoked
# 
source $HOME/.xprofile

# systray icons
exec volumeicon &
exec blueman-applet &

exec qtile
