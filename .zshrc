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

fpath=($(brew --prefix)/share/zsh-completions $fpath)
autoload -Uz compinit
compinit -u

alias ls='ls -F'
alias mkdir='mkdir -p'
alias vim='nvim'
alias gitst='git status'
alias bw-s='npx browser-sync start --server --online --no-notify --files *'
alias bw-sc='npx browser-sync start --config ./bs-config.js'
alias dcp='docker-compose'
alias acvDir='git-diff-archive'
alias py3serv='python3 -m http.server 8000'
alias vscode='open -a Visual\ Studio\ Code'

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

setopt autopushd
setopt pushd_ignore_dups
setopt auto_cd
setopt list_packed
setopt list_types
setopt correct
setopt complete_in_word

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt share_history
setopt EXTENDED_HISTORY

stty stop undef
stty start undef
