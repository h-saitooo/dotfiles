function git-prompt {
  local branch_name
  local st
  local st_symbol=""

  if [ ! -e ".git" ]; then
    return
  fi

  branch_name=`git symbolic-ref --short HEAD`
  st=`git status 2> /dev/null`

  if [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    st_symbol+="!"
  fi
  if [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    st_symbol+="*"
  fi
  if [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    st_symbol+="+"
  fi
  if [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    st_symbol+=" ${fg[red]}@@${reset_color}"
  fi

  echo "on %F{magenta}$branch_name%f %F{yellow}$st_symbol%f"
}

