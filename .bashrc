#                   ___           ___           ___           ___           ___
#    _____         /  /\         /  /\         /__/\         /  /\         /  /\
#   /  /::\       /  /::\       /  /:/_        \  \:\       /  /::\       /  /:/
#  /  /:/\:\     /  /:/\:\     /  /:/ /\        \__\:\     /  /:/\:\     /  /:/
# /  /:/~/::\   /  /:/~/::\   /  /:/ /::\   ___ /  /::\   /  /:/~/:/    /  /:/  ___
#/__/:/ /:/\:| /__/:/ /:/\:\ /__/:/ /:/\:\ /__/\  /:/\:\ /__/:/ /:/___ /__/:/  /  /\
#\  \:\/:/~/:/ \  \:\/:/__\/ \  \:\/:/~/:/ \  \:\/:/__\/ \  \:\/:::::/ \  \:\ /  /:/
# \  \::/ /:/   \  \::/       \  \::/ /:/   \  \::/       \  \::/~~~~   \  \:\  /:/
#  \  \:\/:/     \  \:\        \__\/ /:/     \  \:\        \  \:\        \  \:\/:/
#   \  \::/       \  \:\         /__/:/       \  \:\        \  \:\        \  \::/
#    \__\/         \__\/         \__\/         \__\/         \__\/         \__\/
#
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

#Let ctrl+s and ctrl+q free for use
stty stop ''; stty start '';
stty -ixon
shopt -s autocd

#Glorious vim mode
set -o vi

#colors in ps1
#no colors in ps1
#export PS1="\u @\h >\[$(tput sgr0)\]"

PROMPT_COMMAND='PS1_CMD1="$(git branch --show-current 2>/dev/null || echo "")"';
PS1='\[\033[38;5;14m\]\u@\[$(tput sgr0)\]\[\033[38;5;198m\]\W\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;226m\]\[$(tput sgr0)\]\[\033[38;5;198m\]${PS1_CMD1}\[$(tput sgr0)\]>\[$(tput sgr0)\] '
export PS1

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(starship init bash)"
