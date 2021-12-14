#!/bin/bash

set -eo pipefail

SUBBOARD=$1

if [[ "$(id -u)" -ne "0" ]]; then
    echo "This script requires root."
    exit 1
fi

mkdir -p /tmp/u-boot /usr/lib/u-boot-${SUBBOARD}
dpkg -X /packages/${SUBBOARD}-*ubootimg*.deb /tmp/u-boot
cp -rv /tmp/u-boot/usr/lib/u-boot-${SUBBOARD}/* /usr/lib/u-boot-${SUBBOARD}
