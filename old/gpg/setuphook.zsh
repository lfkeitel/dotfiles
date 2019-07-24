# Start gpg-agent if it's not running
if [ -z "$(pidof gpg-agent 2> /dev/null)" ]; then
    gpg-agent --homedir $HOME/.gnupg --daemon --sh --enable-ssh-support > $HOME/.gnupg/env
fi

if [ -f "$HOME/.gnupg/env" ]; then
    source $HOME/.gnupg/env
fi

if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
