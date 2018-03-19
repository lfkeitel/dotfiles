#!/bin/zsh
DOCKER_HOSTS_DIR="${DOCKER_HOSTS_DIR:-$HOME/.docker/hosts}"

docker-host() {
add_host() {
    host_name="$1"
    address="$2"

    if [ -z "$host_name" ]; then
        echo "I need a name for this host"
        return 1
    fi

    if [ -z "$address" ]; then
        echo "I need an address for this host"
        return 1
    fi

    if [ -f "$DOCKER_HOSTS_DIR/$host_name" ]; then
        echo "Host $host_name already exists. Please remove the host first or use the update command."
        return 1
    fi

    write_host_to_file "$host_name" "$address"
}

update_host() {
    host_name="$1"
    address="$2"

    if [ -z "$host_name" ]; then
        echo "I need a name for this host"
        return 1
    fi

    if [ -z "$address" ]; then
        echo "I need an address for this host"
        return 1
    fi

    if [ ! -f "$DOCKER_HOSTS_DIR/$host_name" ]; then
        echo "Host $host_name doesn't exist. Please use the add command."
        return 1
    fi

    write_host_to_file "$host_name" "$address"
}

write_host_to_file() {
    cat > "$DOCKER_HOSTS_DIR/$host_name" << EOF
$2
$1
EOF
}

rm_host() {
    host_name=$1

    if [ -z "$host_name" ]; then
        echo "I need a name for this host"
        return 1
    fi

    if [ ! -f "$DOCKER_HOSTS_DIR/$host_name" ]; then
        return
    fi

    rm "$DOCKER_HOSTS_DIR/$host_name"
}

ls_hosts() {
    find "$DOCKER_HOSTS_DIR" -type f -printf "%f\n"
}

connect_host() {
    host_name="$1"

    if [ -z "$host_name" ]; then
        echo "I need a name for this host"
        return 1
    fi

    if [ ! -f "$DOCKER_HOSTS_DIR/$host_name" ]; then
        echo "Host $host_name doesn't exist."
        return 1
    fi

    export DOCKER_HOST="$(head -n 1 "$DOCKER_HOSTS_DIR/$host_name")"
    export DOCKER_TLS_VERIFY=1
    export DOCKER_HOST_NAME="$(tail -n 1 "$DOCKER_HOSTS_DIR/$host_name")"
}

active_host() {
    if [ -n "$DOCKER_HOST_NAME" ]; then
        echo "$DOCKER_HOST_NAME"
    fi
}

disconnect_host() {
    export DOCKER_HOST=
    export DOCKER_HOST_NAME=
}

show_help() {
    cat << EOF
Usage: docker-host COMMAND [hostname] [address]

docker-host is a small wrapper around the environment variables needed to connect
securely to remote Docker engines.

Commands:
    add         - Add a new host
    update      - Update a host's Docker address
    rm          - Remove a host
    ls          - List all hosts
    connect     - Connect to a remote Docker engine
    active      - Print the currently active Docker host
    disconnect  - Disconnect from a remote Docker engine.
    help        - Show this text.

Connecting to a remote engine:

    Replace \$HOSTNAME with a memorable name for the Docker host.
    Replace \$IP with the IP address of the remote host.

    $ docker-host add \$HOSTNAME tcp://\$IP:2376 # Add host to docker-host
    $ docker-host connect \$HOSTNAME             # Set environment variables
    $ docker ps                                  # Work on remote host as if it's local
EOF
}

if [ ! -d "$DOCKER_HOSTS_DIR" ]; then
    mkdir -p "$DOCKER_HOSTS_DIR"
fi

case "$1" in
    add) shift; add_host "$@";;
    update) shift; update_host "$@";;
    rm) shift; rm_host "$@";;
    ls) ls_hosts;;
    connect) shift; connect_host "$@";;
    active) shift; active_host "$@";;
    disconnect) disconnect_host;;
    *) show_help;
esac
}
