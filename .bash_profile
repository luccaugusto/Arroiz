#!/bin/sh

# Profile file. Runs on login.

#Default programs
export EDITOR="vim"
export TERMINAL="st"
export READER="zathura"
#in case xdg settings doesn't use $BROWSER value
#xdg-settings set default-web-browser $BROWSER.desktop
export BROWSER="vivaldi-stable"

# Cleaning my home
export CONFIG="$HOME/.config"
export XDG_CONFIG_HOME="$CONFIG"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

#Adding everything i need to my path
export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
export PATH="$PATH:$HOME/.scripts"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.gem/ruby/2.6.0/bin"
export PATH="$PATH:$JAVA_HOME/bin"
#Only when using django
#export PYTHONPATH="$PYTHONPATH:$HOME/Repos/S_Admin/meteflix/apps"

#Others
export GROFF_ENCODING=UTF-8
export BEEP="/usr/share/sounds/freedesktop/stereo/complete.oga"
export mygit='https://github.com/lrr68/'


[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start graphical server if bspwm not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep -x bspwm || exec startx
fi
if [[ "$(tty)" = "/dev/tty2" ]]; then
	pgrep -x tmux || tmux
fi
