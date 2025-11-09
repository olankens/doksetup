#!/bin/bash

# shellcheck disable=SC2155

update_crowdsec() {

    # Update package
    curl -s https://install.crowdsec.net | sudo sh
    sudo apt update && sudo apt install crowdsec

    # Update bouncer
    sudo apt install crowdsec-firewall-bouncer-iptables -y

    # Create rules
    sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
    sudo iptables -P INPUT DROP
    sudo apt install iptables-persistent -y
    sudo netfilter-persistent save

}

update_dokploy() {

    # Verify presence
    local present=$(command -v docker &>/dev/null && docker info &>/dev/null && echo true || echo false)

    # Launch install or update
    if [[ $present == "false" ]]; then
        curl -sSL https://dokploy.com/install.sh | sh
    else
        curl -sSL https://dokploy.com/install.sh | sh -- update
    fi

}

update_system() {

    # Update system
    sudo apt update && sudo apt upgrade -y

    # Create master
    adduser dragos
    usermod -aG sudo dragos

    # Config passwordless
    echo "dragos ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/dragos
    sudo chmod 0440 /etc/sudoers.d/dragos

    # Enable ssh key authentication
    mkdir -p /home/dragos/.ssh
    cp /root/.ssh/authorized_keys /home/dragos/.ssh/
    chown -R dragos:dragos /home/dragos/.ssh
    chmod 700 /home/dragos/.ssh
    chmod 600 /home/dragos/.ssh/authorized_keys

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
