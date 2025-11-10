#!/bin/bash

# shellcheck disable=SC2155

update_crowdsec() {

    # Update package
    curl -s https://install.crowdsec.net | sudo sh
    sudo apt update && sudo apt install crowdsec

    # Update bouncer
    sudo apt install  -y crowdsec-firewall-bouncer-iptables

    # Create rules
    sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
    sudo iptables -P INPUT DROP
    sudo DEBIAN_FRONTEND=noninteractive apt install -y iptables-persistent
    sudo netfilter-persistent save

}

update_dokploy() {

    # Update package
    local present=$(command -v docker &>/dev/null && docker info &>/dev/null && echo true || echo false)
    curl -sSL https://dokploy.com/install.sh | sh "$([[ $present == "true" ]] && echo "-- update")"

}

update_system() {

    # Handle parameters
    local newuser=${1:-master}

    # Update system
    sudo apt update && sudo apt upgrade -y

    # Create master
    adduser "$newuser"
    usermod -aG sudo "$newuser"

    # Config passwordless
    echo "$newuser ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$newuser"
    sudo chmod 0440 "/etc/sudoers.d/$newuser"

    # Enable ssh key authentication
    mkdir -p "/home/$newuser/.ssh"
    cp /root/.ssh/authorized_keys "/home/$newuser/.ssh/"
    chown -R "$newuser:$newuser" "/home/$newuser/.ssh"
    chmod 700 "/home/$newuser/.ssh"
    chmod 600 "/home/$newuser/.ssh/authorized_keys"

    # Remove ssh root access
    # TODO: https://www.bitdoze.com/dokploy-install/#disable-root-ssh-access

    # Reduce ssh session timeout
    # TODO: https://www.bitdoze.com/dokploy-install/#limit-ssh-session-timeout

    # Create swap
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

}

# update_system
update_crowdsec
update_dokploy
