#!/bin/sh

# Profile file. Runs on login.

export EDITOR="vim"
export TERMINAL="st"
export BROWSER="vivaldi-stable"
#xdg-settings set default-web-browser $BROWSER.desktop
export READER="zathura"
export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
export PATH="$PATH:$HOME/.scripts"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.gem/ruby/2.6.0/bin"
export PATH="$PATH:$JAVA_HOME/bin"
export GROFF_ENCODING=UTF-8
export PYTHONPATH="$PYTHONPATH:$HOME/Repos/S_Admin/meteflix/apps"
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
