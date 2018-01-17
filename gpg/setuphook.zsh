if [ "$(uname)" = 'Darwin' ]; then
    addtopath '/usr/local/opt/gpg-agent/bin' # gpg-agent
    addtopath '/Applications/Visual Studio Code.app/Contents/Resources/app/bin' after # VS Code
fi

# Start gpg-agent if it's not running
if ! pidof gpg-agent > /dev/null; then
    gpg-agent --homedir $HOME/.gnupg --daemon --sh --enable-ssh-support > $HOME/.gnupg/env
fi
if [ -f "$HOME/.gnupg/env" ]; then
    source $HOME/.gnupg/env
fi

if [ "$(uname)" = "Darwin" ]; then
    export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
fi