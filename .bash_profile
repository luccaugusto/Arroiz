#!/bin/bash

# Profile file. Runs on login.

#Default programs
export EDITOR="nvim"
export TERMINAL="alacritty"
export READER="zathura"
export BROWSER="brave"
#in case xdg settings doesn't use $BROWSER value
#xdg-settings set default-web-browser brave-browser.desktop

# No history limit
export HISTSIZE=-1

# Cleaning my home
export CONFIG="$HOME/.config"
export XDG_CONFIG_HOME="$CONFIG"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/.local/gems"

#Adding everything i need to my path
export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
# Adds `~/.local/bin` and subdirectories to $PATH
export PATH="$PATH:$(find ~/.local/bin -type d -printf %p:)"
export PATH="$PATH:$JAVA_HOME/bin"
export PATH="$PATH:$HOME/.local/gems/bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"

#Others
export GROFF_ENCODING=UTF-8
export mygit='https://github.com/luccaugusto/'
export REPOS="$HOME/repos"
export NOTES_PATH="$HOME/.config/anote"
export EMAIL='lucca@luccaaugusto.xyz'
export MPD_HOST='127.0.0.59'
export MPD_PORT='2002'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

[[ -f ~/.bashrc ]] && . "$HOME/.bashrc"
[[ -f ~/.fzf-bindings.bash ]] && . "$HOME/.fzf-bindings.bash"
[[ -f ~/.fzf-completion.bash ]] && . "$HOME/.fzf-completion.bash"
[[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Start graphical server if bspwm not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep -x bspwm || exec startx &> .xerrors
	pgrep -x dwm && .local/bin/startup_progs
elif [[ "$(tty)" = "/dev/tty2" ]]; then
	. .cache/wal/colors-tty.sh
	pgrep -x tmux || tmux
fi
