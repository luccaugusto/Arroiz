HISTFILE=~/.shhistory
HISTSIZE=1000
SAVEHIST=10000
unsetopt beep
setopt noflowcontrol

bindkey -v
bindkey "^R" history-incremental-pattern-search-backward

zstyle :compinstall filename '/home/lucca/.zshrc'

[ -f ~/.aliases ] && source ~/.aliases

autoload -Uz compinit
compinit

eval "$(starship init zsh)"

eval "$(rbenv init -)"
