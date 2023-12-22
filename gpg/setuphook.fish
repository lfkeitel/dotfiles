# Start gpg-agent if it's not running
if which gpg-agent
    if [ -z (pidof gpg-agent 2> /dev/null) ]
        gpg-agent --homedir $HOME/.gnupg --daemon --sh --enable-ssh-support > $HOME/.gnupg/env
    end

    set -xg SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end
