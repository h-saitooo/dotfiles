PS1="[%F{cyan}${USER}%f@${HOST%%.*} %F{magenta}%1~%f]%(!.#.$) "

PATH=$PATH:/usr/local/bin:~/bin:$HOME/.nodebrew/current/bin:~/Library/Android/sdk/tools


alias ls='ls -CF'
alias mkdir='mkdir -p'
alias gitst='git status'
alias ssh_shintomei='ssh -L 10022:10.31.0.57:22 creem@203.137.183.249 -p 22 -i ~/creem/nexco_central/01_document/task_info/shin-tomei/server/id_rsa'
alias ssh_tomeiyokohama='ssh -L 10022:203.137.183.249:22 creem@203.137.183.249 -p 22 -i ~/creem/nexco_central/01_document/task_info/shin-tomei/server/id_rsa'
alias bw-s='browser-sync start --server --online --no-notify --files *'
alias bw-sc='browser-sync start --config ./bs-config.js'
alias dcp='docker-compose'


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

function git_diff_archive()
{
  local diff=""
  local h="HEAD"
  local name="archive"
  local date=`date +%y%m%d`
  local root=""
  if [ $# -eq 1 ]; then
    name="$1"
    root="$1"
  elif [ $# -eq 2 ]; then
    name="$1"
    root="$1"
    if expr "$2" : '[0-9]*$' > /dev/null ; then
      diff="HEAD~${2} HEAD"
    else
      diff="${2} HEAD"
    fi
  elif [ $# -eq 3 ]; then
    name="$1"
    root="$1"
    diff="${3} ${2}"
    h=$2
  elif [ $# -eq 4 ]; then
    name="$1"
    root="$4"
    diff="${3} ${2}"
    h=$2
  fi
  if [ "$diff" != "" ]; then
    diff="git diff --diff-filter=d --name-only ${diff}"
  fi
  git archive --format=zip --prefix=$root/ $h `eval $diff` -o ~/desktop/${date}_${name}_data.zip
}
