#!/bin/bash

set -eo pipefail

BOARD=$1

if [[ "$(id -u)" -ne "0" ]]; then
    echo "This script requires root."
    exit 1
fi

# Fix /boot/boot.cmd and /boot/boot.scr
if [[ -f "/boot/boot-${BOARD}.cmd" ]] && [[ -f "/boot/boot-${BOARD}.scr" ]]  ; then
    cp /boot/boot-${BOARD}.cmd /boot/boot.cmd
    cp /boot/boot-${BOARD}.scr /boot/boot.scr
    rm -f /boot/boot-${BOARD}.cmd /boot/boot-${BOARD}.scr

    echo "I: show /boot/boot.scr"
    cat /boot/boot.scr
fi
