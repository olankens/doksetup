#!/bin/bash

# shellcheck disable=SC2015,SC2034,SC2059,SC2155

invoke_wrapper() {

	# Handle parameters
	local welcome=${1}
	local members=("${@:2}")

	# Output welcome
	clear && printf "\033[92m%s\033[00m\n\n" "$welcome"

	# Prompt password
	sudo -v
	local results=$?
	printf "\n"
	[[ $results -ne 0 ]] && return 1
	clear && printf "\033[92m%s\033[00m\n\n" "$welcome"

	# Remove timeouts
	echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/disable_timeout" >/dev/null

	# Output progress
	local logfile="/tmp/doksetup_$(date +%Y%m%d_%H%M%S).log"
	local bigness=$((${#welcome} / $(echo "$welcome" | wc -l)))
	local heading="\r%-"$((bigness - 19))"s   %-5s   %-8s\n\n"
	local loading="\033[93m\r%-"$((bigness - 19))"s   %02d/%02d   %-8s\b\033[0m"
	local failure="\033[91m\r%-"$((bigness - 19))"s   %02d/%02d   %-8s\n\033[0m"
	local success="\033[92m\r%-"$((bigness - 19))"s   %02d/%02d   %-8s\n\033[0m"
	printf "$heading" "FUNCTION" "ITEMS" "DURATION"
	local minimum=1 && local maximum=${#members[@]}
	for element in "${members[@]}"; do
		local written=$(basename "$(echo "$element" | cut -d "'" -f 1)" | tr "[:lower:]" "[:upper:]")
		local started=$(date +"%s") && printf "$loading" "$written" "$minimum" "$maximum" "--:--:--"
		eval "$element" >>"$logfile" 2>&1 && local current="$success" || local current="$failure"
		local extinct=$(date +"%s") && elapsed=$((extinct - started))
		local elapsed=$(printf "%02d:%02d:%02d\n" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60)))
		printf "$current" "$written" "$minimum" "$maximum" "$elapsed" && ((minimum++))
	done

	# Revert timeouts
	sudo rm "/etc/sudoers.d/disable_timeout" 2>/dev/null

	# Output newline
	printf "\n"

}

update_crowdsec() {

	# Update package
	curl -s https://install.crowdsec.net | sudo sh
	sudo apt update && sudo apt install crowdsec

	# Update bouncer
	sudo apt install -y crowdsec-firewall-bouncer-iptables

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
	[[ "$present" == "false" ]] && curl -sSL https://dokploy.com/install.sh | sudo sh
	curl -sSL https://dokploy.com/install.sh | sudo sh -s -- update

}

update_system() {

	# Update system
	sudo apt update -qq && sudo apt upgrade -y -qq

	# Create swap
	[[ -f "/swapfile" ]] || sudo fallocate -l 2G "/swapfile"
	sudo chmod 600 "/swapfile"
	sudo mkswap "/swapfile"
	sudo swapon "/swapfile"
	grep -q "/swapfile" "/etc/fstab" || echo "/swapfile none swap sw 0 0" | sudo tee -a "/etc/fstab"

}

main() {

	read -r -d "" welcome <<-EOD
		██████╗░░█████╗░██╗░░██╗░██████╗███████╗████████╗██╗░░░██╗██████╗░
		██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔════╝╚══██╔══╝██║░░░██║██╔══██╗
		██║░░██║██║░░██║█████═╝░╚█████╗░█████╗░░░░░██║░░░██║░░░██║██████╔╝
		██║░░██║██║░░██║██╔═██╗░░╚═══██╗██╔══╝░░░░░██║░░░██║░░░██║██╔═══╝░
		██████╔╝╚█████╔╝██║░╚██╗██████╔╝███████╗░░░██║░░░╚██████╔╝██║░░░░░
		╚═════╝░░╚════╝░╚═╝░░╚═╝╚═════╝░╚══════╝░░░╚═╝░░░░╚═════╝░╚═╝░░░░░
	EOD
	local members=("update_system" "update_crowdsec" "update_dokploy")
	invoke_wrapper "$welcome" "${members[@]}"

}

main "$@"
