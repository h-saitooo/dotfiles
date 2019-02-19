PS1="[%F{cyan}${USER}%f@${HOST%%.*} %F{magenta}%1~%f]%(!.#.$) "

PATH=/usr/local/Cellar/git/2.19.2/bin:/usr/local/bin:~/bin:$HOME/.nodebrew/current/bin:~/Library/Android/sdk/tools:$PATH

alias ls='ls -CF'
alias mkdir='mkdir -p'
alias gitst='git status'
alias bw-s='browser-sync start --server --online --no-notify --files *'
alias bw-sc='browser-sync start --config ./bs-config.js'
alias dcp='docker-compose'
alias acvDir='archive_diff_dir'

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

function archive_diff_dir()
{
  local diff=""
  local name="archive"
  local h="HEAD"
  local start=""
  local end=""
  local root=""
  local dir=""
  local date=`date +%y%m%d`
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
    if expr "$2" : '[0-9]*$' > /dev/null ; then
      start="HEAD~${2}"
    else
      start="$2"
    fi
    if expr "$3" : '[0-9]*$' > /dev/null ; then
      end="HEAD~${3}"
    else
      end="$3"
    fi
    h=$end
    diff="${start} ${end}"
  elif [ $# -eq 4 ]; then
    name="$1"
    if expr "$2" : '[0-9]*$' > /dev/null ; then
      start="HEAD~${2}"
    else
      start="$2"
    fi
    if expr "$3" : '[0-9]*$' > /dev/null ; then
      end="HEAD~${3}"
    else
      end="$3"
    fi
    if expr "$4" : '^:' > /dev/null ; then
      dir="$4"
      root="$1"
    else
      dir=""
      root="$4"
    fi
    h="${end}${dir}"
    diff="${start}${dir} ${end}${dir}"
  elif [ $# -eq 5 ]; then
    name="$1"
    dir="$4"
    root="$5"
    if expr "$2" : '[0-9]*$' > /dev/null ; then
      start="HEAD~${2}"
    else
      start="$2"
    fi
    if expr "$3" : '[0-9]*$' > /dev/null ; then
      end="HEAD~${3}"
    else
      end="$3"
    fi
    h="${end}${dir}"
    diff="${start}${dir} ${end}${dir}"
  fi
  if [ "$diff" != "" ]; then
    diff="git diff --diff-filter=d --name-only ${diff}"
  fi
  git archive --format=zip --prefix=$root/ $h `eval $diff` -o ~/desktop/${date}_${name}_data.zip
}
