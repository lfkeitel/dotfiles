# Start gpg-agent if it's not running
if [ -z "$(pidof gpg-agent 2> /dev/null)" ]; then
    gpg-agent --homedir $HOME/.gnupg --daemon --sh --enable-ssh-support > $HOME/.gnupg/env
fi

if [ -f "$HOME/.gnupg/env" ]; then
    source $HOME/.gnupg/env
fi
