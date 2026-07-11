#!/usr/bin/env zsh

# Start graphical server if WM not already running.
if [ ! "$(systemctl is-enabled ly)" = "enabled" ]; then
	if [[ "$(tty)" = "/dev/tty2" ]]; then
		. .cache/wal/colors-tty.sh
		pgrep -x tmux || tmux
	fi
else
	if [[ "$(tty)" = "/dev/tty1" ]]; then
		. .cache/wal/colors-tty.sh
		pgrep -x tmux || tmux
	fi
fi
