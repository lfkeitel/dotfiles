export NVM_DIR="$HOME/.nvm"
# Lazy load nvm only when called
nvm() {
    unset -f nvm
    if [ "$(uname)" = "Darwin" ]; then
        [ -s "/usr/local/opt/nvm/nvm.sh"  ] && \. "/usr/local/opt/nvm/nvm.sh"
    else
        [ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh"
    fi
    nvm "$@"
}
