#!/bin/sh

# Profile file. Runs on login.

export PATH="$PATH:$HOME/.scripts"
export EDITOR="vim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start graphical server if i3 not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep -x i3 || exec startx
fi

. pulshes
notify-send "$(anote -l)"
