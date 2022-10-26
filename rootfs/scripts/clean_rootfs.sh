#!/bin/bash

set -eo pipefail

if [[ "$(id -u)" -ne "0" ]]; then
    echo "This script requires root."
    exit 1
fi

# The content of file /testing-system is overwritten by Jenkinsfile
#if [[ -e "/testing-system" ]] && [[ "$(cat /testing-system)" == "yes" ]]; then
#    echo "192.168.2.8 deb.debian.org">> /etc/hosts
#fi

chmod o+x /usr/lib/dbus-1.0/dbus-daemon-launch-helper

# Custom Script 
systemctl mask systemd-networkd-wait-online.service
systemctl mask NetworkManager-wait-online.service

# Only preload libdrm-cursor for X
#sed -i "/libdrm-cursor.so/d" /etc/ld.so.preload
#sed -i "1aexport LD_PRELOAD=libdrm-cursor.so.1" /usr/bin/X

# Clean rootfs
rm -rf /etc/apt/sources.list.d/*.key
rm -rf /packages
rm -rf /var/lib/apt/lists/*
rm -rf /lib/systemd/system/wpa_supplicant@.service

# Disable dhcpcd service. Instead we use NetworkManager.
systemctl disable dhcpcd > /dev/null || true

find / -name ".gitkeep" | xargs rm  || true
