# Config Files
Most config files I use. I welcome suggestions :)

## Usage
**WIP**
* Qtile: change the Wlan and Net widget interfaces in getBar()

## Dependencies (other than configured apps)
**WIP**
* qtile/X11:
  * (xorg)
  * dmenu
  * urxvt
  * pulsemixer (& pulseaudio)
  * mpc
  * volumeicon
  * blueman
  * feh

## Reasons for specific Programs
* qtile: includes systray + statusbar, proper fullscreen
  * exwm: too buggy & single threaded, slow startup, ugly windows
  * dwm: needs external script for statusbar, needs compiling, python easier than C
  * xmonad: no systray, no statusbar, GHC (500mb) dependency
* emacs: evil>vim, many functions (eg music/mpd client), one config file for everything
* zsh: completion system
* urxvt
  * st, xterm: no line wrap
  * vte: no image preview (ranger)
