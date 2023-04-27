#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
export PS1='[\u@\h \W]\$ '
export EDITOR='vim'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export GPG_TTY=$(tty)
