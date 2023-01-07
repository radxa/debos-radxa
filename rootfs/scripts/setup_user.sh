#!/bin/bash

set -eo pipefail

if [[ "$(id -u)" -ne "0" ]]; then
     echo "This script requires root."
     exit 1
fi

# setup user
USER="wemaintain"
PASSWORD="onesttoosla"

adduser --gecos "$USER" \
        --disabled-password \
        --shell /bin/bash \
        "$USER"

adduser "$USER" audio
adduser "$USER" sudo
adduser "$USER" video
#adduser "$USER" render

echo "$USER:$PASSWORD" | chpasswd
