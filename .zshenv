#Default programs
export EDITOR="nvim"
export TERMINAL="kitty"
# export TERMINAL="alacritty"
export READER="zathura"
export BROWSER="brave"
#in case xdg settings doesn't use $BROWSER value
#xdg-settings set default-web-browser brave-browser.desktop
#
# Cleaning my home
export CONFIG="$HOME/.config"
export XDG_CONFIG_HOME="$CONFIG"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export XDG_CURRENT_DESKTOP="Hyprland"
# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/.local/gems"

#Adding everything i need to my path
export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
# Adds `~/.local/bin` and subdirectories to $PATH

PATH="$PATH:$(find -L ~/.local/bin -type d -printf %p:)"
export PATH="$PATH:$JAVA_HOME/bin"
export PATH="$PATH:$HOME/.local/gems/bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.3.0/bin"

#Others
export GROFF_ENCODING=UTF-8
export mygit='https://github.com/luccaugusto/'
export REPOS="$HOME/repos"
export NOTES_PATH="$HOME/.config/anote"
export EMAIL='lucca@luccaaugusto.xyz'
export MPD_HOST='127.0.0.59'
export MPD_PORT='2002'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

export GTK_USE_PORTAL=1

export OPENCV_LOG_LEVEL=0
export OPENCV_VIDEOIO_PRIORITY_INTEL_MFX=0

[ -f ~/.Xresources ] && [ "$XDG_CURRENT_DESKTOP" != "Hyprland" ] && xrdb -merge ~/.Xresources

# # The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/lucca/repos/google-cloud-sdk/path.zsh.inc' ]; then . '/home/lucca/repos/google-cloud-sdk/path.zsh.inc'; fi
#
# # The next line enables shell command completion for gcloud.
# if [ -f '/home/lucca/repos/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/lucca/repos/google-cloud-sdk/completion.zsh.inc'; fi

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
