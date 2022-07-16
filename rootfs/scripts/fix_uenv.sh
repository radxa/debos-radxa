#!/bin/bash

set -eo pipefail

BOARD=$1

if [[ "$(id -u)" -ne "0" ]]; then
    echo "This script requires root."
    exit 1
fi

# Overwrite /boot/uEnv.txt
if [[ -f "/boot/uEnv-${BOARD}.txt" ]]; then
    cp /boot/uEnv-${BOARD}.txt /boot/uEnv.txt
    rm -f /boot/uEnv-*.txt

    # Overwrite rootuuid
    echo "rootuuid=`cat /etc/kernel/cmdline | cut -d "=" -f 3`" >> /boot/uEnv.txt

    echo "I: show /boot/uEnv.txt"
    cat /boot/uEnv.txt
fi
