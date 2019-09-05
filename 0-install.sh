#!/bin/bash

choice=$(echo -e "install\nquit" | dmenu -i)
if [ $choice = "quit" ]
then
    exit 0
else
# X11
ln -f xinitrc                 $HOME/.xinitrc
ln -f xresources              $HOME/.config/xresources
ln -f wallpaper               $HOME/.config/wallpaper
ln -f user-dirs.dirs          $HOME/.config/user-dirs.dirs
ln -f qtile.py                $HOME/.config/qtile/config.py
# Shell
ln -f xprofile                $HOME/.xprofile
ln -f zprofile.zsh            $HOME/.zprofile
ln -f zsh.zsh                 $HOME/.config/zsh/.zshrc
# Applications
##Home Folder
ln -f init.el                 $HOME/.emacs.d/init.el
ln -f gitconfig               $HOME/.gitconfig
ln -f ideavimrc               $HOME/.ideavimrc
## Config Folder
ln -f mpd                     $HOME/.config/mpd/mpd.conf

ln -f ideakeymap              "$HOME/.Webstorm*/config/keymaps/Default for XWin copy.xml"

fi

