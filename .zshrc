PS1="[%F{cyan}${USER}%f@${HOST%%.*} %F{magenta}%1~%f]%(!.#.$) "

PATH


RPROMPT="%T"
setopt transient_rprompt
setopt prompt_subst
bindkey -e
export LANG=ja_JP.UTF-8
export EDITOR=vim

autoload -Uz compinit
compinit -u
setopt autopushd
setopt pushd_ignore_dups
setopt auto_cd
setopt list_packed
setopt list_types
setopt correct

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt share_history
setopt EXTENDED_HISTORY

zstyle ':completion:*:default' menu select=1
