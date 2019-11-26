#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
eval "$(direnv hook zsh)"

#anyenv init
if which anyenv > /dev/null; then eval "$(anyenv init -)"; fi
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init - zsh)"

# rbenv init
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

alias ls='ls -CF'
alias mkdir='mkdir -p'
alias gitst='git status'
alias bw-s='browser-sync start --server --online --no-notify --files *'
alias bw-sc='browser-sync start --config ./bs-config.js'
alias dcp='docker-compose'
alias acvDir='git-diff-archive'
alias py3serv='python3 -m http.server 8000'

re-prompt() {
    zle .reset-prompt
    zle .accept-line
}

zle -N accept-line re-prompt

# RPROMPT="%F{cyan}%*%f"
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
