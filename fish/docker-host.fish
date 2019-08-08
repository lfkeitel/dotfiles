# #!/usr/bin/env fish
set -q DOCKER_HOSTS_DIR; or set DOCKER_HOSTS_DIR "$HOME/.docker/hosts"

function docker-host
function add_host -a host_name address
    if [ -z "$host_name" ]
        echo "I need a name for this host"
        return 1
    end

    if [ -z "$address" ]
        echo "I need an address for this host"
        return 1
    end

    if [ -f "$DOCKER_HOSTS_DIR/$host_name" ]
        echo "Host $host_name already exists. Please remove the host first or use the update command."
        return 1
    end

    write_host_to_file "$host_name" "$address"
end

function update_host -a host_name address
    if [ -z "$host_name" ]
        echo "I need a name for this host"
        return 1
    end

    if [ -z "$address" ]
        echo "I need an address for this host"
        return 1
    end

    if [ ! -f "$DOCKER_HOSTS_DIR/$host_name" ]
        echo "Host $host_name doesn't exist. Please use the add command."
        return 1
    end

    write_host_to_file "$host_name" "$address"
end

function write_host_to_file
    echo "\
$2
$1
" > "$DOCKER_HOSTS_DIR/$host_name"
end

function rm_host -a host_name
    if [ -z "$host_name" ]
        echo "I need a name for this host"
        return 1
    end

    if not [ -f "$DOCKER_HOSTS_DIR/$host_name" ]
        return
    end

    rm "$DOCKER_HOSTS_DIR/$host_name"
end

function ls_hosts
    find "$DOCKER_HOSTS_DIR" -type f -printf "%f\n"
end

function connect_host -a host_name
    if [ -z "$host_name" ]
        echo "I need a name for this host"
        return 1
    end

    if [ ! -f "$DOCKER_HOSTS_DIR/$host_name" ]
        echo "Host $host_name doesn't exist."
        return 1
    end

    set -gx DOCKER_HOST (head -n 1 "$DOCKER_HOSTS_DIR/$host_name")
    set -gx DOCKER_TLS_VERIFY 1
    set -gx DOCKER_HOST_NAME (tail -n 1 "$DOCKER_HOSTS_DIR/$host_name")
    echo "Connected to Docker host $host_name"
end

function active_host
    if [ -n "$DOCKER_HOST_NAME" ]
        echo "$DOCKER_HOST_NAME"
    end
end

function disconnect_host
    set -e DOCKER_HOST
    set -e DOCKER_TLS_VERIFY
    set -e DOCKER_HOST_NAME
end

function show_help
    echo "\
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

    \$ docker-host add \$HOSTNAME tcp://\$IP:2376 # Add host to docker-host OR
    \$ docker-host add \$HOSTNAME ssh://\$IP      # Add host to docker-host
    \$ docker-host connect \$HOSTNAME            # Set environment variables
    \$ docker ps                                # Work on remote host as if it's local\
"
end

function set_aliases
    alias dha 'docker-host add'
    alias dhc 'docker-host connect'
    alias dhd 'docker-host disconnect'
    alias dhl 'docker-host ls'
    alias dhls 'docker-host ls'
    alias dhac 'docker-host active'
end

if not [ -d "$DOCKER_HOSTS_DIR" ]
    mkdir -p "$DOCKER_HOSTS_DIR"
end

switch $argv[1]
    case add
        add_host $argv[2..-1]
    case update
        update_host $argv[2..-1]
    case rm
        rm_host $argv[2..-1]
    case ls
        ls_hosts
    case connect
        connect_host $argv[2..-1]
    case active
        active_host $argv[2..-1]
    case disconnect
        disconnect_host
    case set_aliases
        set_aliases
    case '*'
        show_help
end
end
