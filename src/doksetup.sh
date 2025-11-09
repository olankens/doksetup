#!/bin/bash

# shellcheck disable=SC2155

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
