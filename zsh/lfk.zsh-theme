# Based on gnzh theme

setopt prompt_subst

() {
local PR_USER PR_USER_OP PR_PROMPT PR_HOST

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%f➤ %f'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤ %f'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='@%F{red}%M%f' # SSH
fi

local return_code="%(?..%F{red}%? ↵%f)"

local user_host="${PR_USER}%F{cyan}${PR_HOST}"
local git_branch='$(git_prompt_info)'
local prompt_date='$(date +"%Y-%d-%m %H:%M:%S")'

shorten_pwd() {
  echo -n "%B%F{blue}"
  echo -n ${${:-/${(j:/:)${(M)${(s:/:)${(D)PWD:h}}#(|.)[^.]}}/${PWD:t}}//\/~/\~}
  echo -n "%f%b"
}
local current_dir='$(shorten_pwd)'

get_active_docker_host() {
  local active="$(docker-host active 2>/dev/null)"
  if [ -n "$active" ]; then
    echo -n "%B%F{yellow}"
    echo -n "‹$active› "
    echo -n "%f%b"
  fi
}
local active_docker_host='$(get_active_docker_host)'

PROMPT="${user_host} ${current_dir} ${git_branch} ${active_docker_host}
${prompt_date} $PR_PROMPT "
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%f"
}
