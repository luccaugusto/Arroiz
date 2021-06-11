#!/bin/sh

# Profile file. Runs on login.

#Default programs
export EDITOR="vim"
export TERMINAL="st"
export READER="zathura"
export BROWSER="brave"
#in case xdg settings doesn't use $BROWSER value
#xdg-settings set default-web-browser brave.desktop

# No history limit
export HISTSIZE=-1

# Cleaning my home
export CONFIG="$HOME/.config"
export XDG_CONFIG_HOME="$CONFIG"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

#Adding everything i need to my path
export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
# Adds `~/.local/bin` and subdirectories to $PATH
export PATH="$PATH:$(find ~/.local/bin -type d -printf %p:)"
export PATH="$PATH:$HOME/.gem/ruby/2.7.0/bin"
export PATH="$PATH:$JAVA_HOME/bin"

#Others
export GROFF_ENCODING=UTF-8
export mygit='https://github.com/lrr68/'
export REPOS="$HOME/repos"
export NOTES_PATH="$HOME/.config/anote"
export EMAIL='lucca@luccaaugusto.xyz'


[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start graphical server if bspwm not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep -x bspwm || exec startx &> .xerrors
	pgrep -x dwm && .local/bin/startup_progs
fi
if [[ "$(tty)" = "/dev/tty2" ]]; then
	. .cache/wal/colors-tty.sh
	pgrep -x tmux || tmux
fi
source "$HOME/.cargo/env"
