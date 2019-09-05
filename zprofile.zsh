# used for executing user's commands at start
# will be sourced when starting as a login shell.

source $HOME/.xprofile
if [ -z "$DISPLAY" ] && [ "$(fgconsole)" -eq 1 ]; then
	exec startx
fi

