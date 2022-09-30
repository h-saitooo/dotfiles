export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export GPG_TTY=$(tty)

# Customize to your needs...
eval "$(direnv hook zsh)"

source $(brew --prefix asdf)/asdf.sh
source ~/.zshrc_local

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
alias awsl='aws --profile localstack --endpoint-url=http://localhost:4566'
alias google-chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

re-prompt() {
    zle .reset-prompt
    zle .accept-line
}

zle -N accept-line re-prompt

setopt transient_rprompt
setopt prompt_subst
bindkey -e
export LANG=ja_JP.UTF-8
export EDITOR=nvim
export GPG_TTY=$(tty)

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

[[ -s "~/.gvm/scripts/gvm" ]] && source "~/.gvm/scripts/gvm"

# source ~/.zsh/git-prompt.zsh
# PROMPT="%F{green}%n%f (%m): %F{cyan}%~%f `git-prompt`"$'\n'"%# "
eval "$(starship init zsh)"
# RPROMPT="%F{cyan}%*%f"

