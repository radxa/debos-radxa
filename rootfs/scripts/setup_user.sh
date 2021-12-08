#!/bin/bash

set -eo pipefail

if [[ "$(id -u)" -ne "0" ]]; then
     echo "This script requires root."
     exit 1
fi

# setup user
USER=${1-rock}

adduser --gecos "$USER" \
        --disabled-password \
        --shell /bin/bash \
        "$USER"

adduser "$USER" audio
adduser "$USER" sudo
adduser "$USER" video
#adduser "$USER" render

echo "$USER:$USER" | chpasswd
