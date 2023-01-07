#!/bin/bash
# Install target board packages.

set -eo pipefail

if [[ "$(id -u)" -ne "0" ]]; then
    echo "This script requires root."
    exit 1
fi

cd /packages
cd /packages
for pkg in $(cat "./kernel-packages.list")
do
    if [[ $pkg == \#* ]]
    then
        echo Skip $pkg
    else
        target_pkg=$(find . -name "$pkg")
        echo "find target package: $target_pkg"
        dpkg -i ${target_pkg}
    fi
done

