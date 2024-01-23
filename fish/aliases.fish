# Application aliases
alias gpg 'gpg2'
alias vim 'nvim'

alias visshc 'vim ~/.ssh/config'
alias todo 'vim ~/todo'

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
alias + 'sudo'
alias fix-mounts 'sudo umount -a -t cifs -l -f'
alias pwdu 'du --max-depth=1 -h .'
alias kill-tmux-sessions 'tmux list-sessions | grep -v attached | cut -d: -f1 | grep -P \'^\\d+$\' |  xargs -t -n1 tmux kill-session -t'
alias sudp 'sudo'
alias sfrc 'source $HOME/.config/fish/config.fish'

alias socksproxy 'ssh -C -N -D'
alias socksproxyb 'ssh -f -C -N -D'

alias psg 'ps aux | grep'
alias noproxy 'ssh -o ProxyCommand=none'

alias ys 'yarn start'
alias yb 'yarn build'
alias yr 'yarn run'

alias p 'code_jump'
alias cat 'better_cat'
alias np 'new_project'

alias mpp 'mpc toggle'
alias mpn 'mpc next'

alias bconsole='bconsole -c $HOME/.config/bconsole/bconsole.conf'

alias G 'grep'
alias L 'less'
alias T 'tail'

alias cb 'cargo build'
alias cbr 'cargo build --release'
alias cr 'cargo run'
alias cu 'cargo update'

alias hbal 'hledger bal --cleared --real'
alias ledger 'ledger --strict'

alias rm-orphans 'sudo /usr/bin/pacman -Rns (/usr/bin/pacman -Qtdq)'
alias ips 'ip -br -color addr'

alias youtube-dl 'youtube-dl -4'
alias headset 'pactl set-sink-port 0 analog-output-speaker && pactl set-sink-port 0 analog-output-headphones'
alias home 'tmux-sessionizer home && cd && clear'

bind \cf "tmux-sessionizer"
