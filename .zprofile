#!/usr/bin/env zsh

# Start graphical server if WM not already running.
if [ ! "$(systemctl is-enabled ly)" = "enabled" ]; then
	if [[ "$(tty)" = "/dev/tty1" ]]; then
		wm="$(tail -n 1 ~/.xinitrc | cut -d ' ' -f 2)"
		pgrep -x "$wm" || exec startx &> .xerrors
		pgrep -x dwm && .local/bin/startup_progs
	elif [[ "$(tty)" = "/dev/tty2" ]]; then
		. .cache/wal/colors-tty.sh
		pgrep -x tmux || tmux
	fi
else
	if [[ "$(tty)" = "/dev/tty1" ]]; then
		. .cache/wal/colors-tty.sh
		pgrep -x tmux || tmux
	fi
fi
