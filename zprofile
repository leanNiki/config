#!/bin/sh
[ -f "$HOME/.config/env" ] && source "$HOME/.config/env"

# start X if on tty1
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx /home/me/.config/xinitrc
fi
