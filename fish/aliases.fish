# Application aliases
alias gpg 'gpg2'
alias nvim 'TERM=screen nvim'
alias vim 'TERM=screen nvim'
alias vi 'TERM=screen nvim'

# Project aliases
alias pjls 'project ls'
alias pjcd 'project cd'
alias pjadd 'project add'

# Deploy shortcuts
alias update-blog 'docker build -t lfkeitel/blog-site . && docker push lfkeitel/blog-site:latest && ssh -4 root@blog.keitel.xyz /root/update-blog.sh'

# Docker
alias digrep 'docker image ls | grep'
alias docker-rm-dangle 'docker image rm (docker image ls -f dangling=true -q)'

# Misc
alias fix-mounts 'sudo umount -a -t cifs -l -f'
alias pwdu 'du --max-depth=1 -h .'
alias kill-tmux-sessions 'tmux list-sessions | grep -v attached | cut -d: -f1 |  xargs -t -n1 tmux kill-session -t'
alias sudp 'sudo'
alias c 'code .'
alias sfrc 'source $HOME/.config/fish/config.fish'

alias gs 'git status'
alias gds 'git diff --staged'

alias socksproxy 'ssh -C -N -D'
alias socksproxyf 'ssh -f -C -N -D'

alias psg 'ps aux | grep'
alias noproxy 'ssh -o ProxyCommand=none'

alias ys 'yarn start'
alias yb 'yarn build'

alias p 'code_jump'
alias cat 'better_cat'
alias np 'new_project'

alias mpp 'mpc toggle'
alias mpn 'mpc next'

alias bconsole="bconsole -c $HOME/.config/bconsole/bconsole.conf"
