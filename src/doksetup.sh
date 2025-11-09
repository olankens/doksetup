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
