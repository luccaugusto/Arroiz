#!/bin/sh

# Profile file. Runs on login.

export EDITOR="vim"
export TERMINAL="st"
export BROWSER="brave"
export READER="zathura"
export PATH="$PATH:$HOME/.scripts"
export PATH="$PATH:$HOME/.gem/ruby/2.6.0/bin"
export PATH="$PATH:$HOME/.local/bin"
export GROFF_ENCODING=UTF-8
export PYTHONPATH="$PYTHONPATH:$HOME/Repos/S_Admin/meteflix/apps"
export BEEP="/usr/share/sounds/freedesktop/stereo/complete.oga"


[[ -f ~/.bashrc ]] && . ~/.bashrc


# Start graphical server if bspwm not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep -x bspwm || exec startx
fi
