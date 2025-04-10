#!/bin/bash

start_xrdp_services() {
    rm -f /var/run/xrdp-sesman.pid
    rm -f /var/run/xrdp.pid
    rm -rf /var/run/xrdp/*

    echo "Starting xrdp-sesman..."
    xrdp-sesman

    echo "Starting xrdp..."
    exec xrdp -n
}

stop_xrdp_services() {
    echo "Stopping xrdp..."
    pkill xrdp
    pkill xrdp-sesman
    exit 0
}

echo "Entrypoint script is running..."

users=$(($#/3))
mod=$(($# % 3))

if [[ $# -eq 0 ]]; then
    echo "No input parameters. Expected: username password sudo_flag"
    exit 1
fi

if [[ $mod -ne 0 ]]; then
    echo "Incorrect input count. Each user must have: username password sudo_flag"
    exit 1
fi

echo "You entered $users users"

while [[ $# -ne 0 ]]; do
    username=$1
    password=$2
    is_sudo=$3

    echo "Creating user: $username"

    # Create user with home dir and bash shell
    useradd -m -s /bin/bash "$username"

    # Set password
    echo "$username:$password" | chpasswd

    # Add to sudo group if flagged
    if [[ "$is_sudo" == "yes" ]]; then
        usermod -aG sudo "$username"
    fi

    # Create basic .xsession file for XRDP
    echo "export XDG_SESSION_TYPE=x11" > /home/$username/.xsession
    echo "exec budgie-desktop" >> /home/$username/.xsession
    chmod +x /home/$username/.xsession
    chown $username:$username /home/$username/.xsession

    shift 3
done

echo "Setup complete."
echo "Starting XRDP services..."

trap "stop_xrdp_services" SIGINT SIGTERM EXIT
start_xrdp_services
