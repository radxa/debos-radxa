#!/bin/bash

set -eo pipefail

if [[ "$(id -u)" -ne "0" ]]; then
    echo "This script requires root."
    exit 1
fi

# Setup dhcpcd wpa_supplicant conf
cp /usr/share/dhcpcd/hooks/10-wpa_supplicant /lib/dhcpcd/dhcpcd-hooks/10-wpa_supplicant

# Desactivate wpa_supplicant service, dhcpcd starts it
rm -rf /lib/systemd/system/wpa_supplicant@.service