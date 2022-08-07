#!/bin/bash

set -eo pipefail

BOARD=$1

if [[ "$(id -u)" -ne "0" ]]; then
    echo "This script requires root."
    exit 1
fi

# Overwrite /boot/config.txt
if [[ -f "/boot/config-${BOARD}.txt" ]]; then
    cp /boot/config-${BOARD}.txt /boot/config.txt
    rm -f /boot/config-*.txt

    echo "I: show /boot/config.txt"
    cat /boot/config.txt
fi
