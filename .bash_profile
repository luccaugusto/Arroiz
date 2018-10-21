#!/bin/sh

# Profile file. Runs on login.

export EDITOR="vim"
export TERMINAL="st"
export BROWSER="firefox"
export READER="zathura"
export JAVA_HOME=/usr/lib/jvm/java-10-openjdk
export PATH="$PATH:$HOME/.scripts"
export PATH="$PATH:$JAVA_HOME/bin"

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start graphical server if i3 not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep -x i3 || exec startx
fi

. pulshes
