#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#Let ctrl+s and ctrl+q free for use
stty stop ''; stty start '';

PS1='[\u@\h \W]\$ '

fortune | ponysay -b linux-vt
