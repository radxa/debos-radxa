#!/bin/bash

set -eo pipefail

if [[ "$(id -u)" -ne "0" ]]; then
    echo "This script requires root."
    exit 1
fi

MODEL=$1
SUITE=$2
APT_REPO=$3

[[ -n ${MODEL} ]] || exit
[[ -n ${SUITE} ]] || exit
[[ -n ${APT_REPO} ]] || exit

# Fix Debian/Ubuntu Official APT Source.
DEBIAN_MIRROR='httpredir.debian.org/debian'
UBUNTU_MIRROR='ports.ubuntu.com/ubuntu-ports/'

rm -rf /etc/apt/sources.list
touch /etc/apt/sources.list

case $SUITE in
stretch|buster|bullseye)
cat <<-EOF > /etc/apt/sources.list
deb http://${DEBIAN_MIRROR} ${SUITE} main contrib non-free
#deb-src http://${DEBIAN_MIRROR} ${SUITE} main contrib non-free

deb http://${DEBIAN_MIRROR} ${SUITE}-updates main contrib non-free
#deb-src http://${DEBIAN_MIRROR} ${SUITE}-updates main contrib non-free

deb http://${DEBIAN_MIRROR} ${SUITE}-backports main contrib non-free
#deb-src http://${DEBIAN_MIRROR} ${SUITE}-backports main contrib non-free

deb http://security.debian.org/ ${SUITE}/updates main contrib non-free
#deb-src http://security.debian.org/ ${SUITE}/updates main contrib non-free
EOF
;;

xenial|bionic|eoan|focal)
cat <<-EOF > /etc/apt/sources.list
deb http://${UBUNTU_MIRROR} ${SUITE} main restricted universe multiverse
#deb-src http://${UBUNTU_MIRROR} ${SUITE} main restricted universe multiverse

deb http://${UBUNTU_MIRROR} ${SUITE}-security main restricted universe multiverse
#deb-src http://${UBUNTU_MIRROR} ${SUITE}-security main restricted universe multiverse

deb http://${UBUNTU_MIRROR} ${SUITE}-updates main restricted universe multiverse
#deb-src http://${UBUNTU_MIRROR} ${SUITE}-updates main restricted universe multiverse

deb http://${UBUNTU_MIRROR} ${SUITE}-backports main restricted universe multiverse
#deb-src http://${UBUNTU_MIRROR} ${SUITE}-backports main restricted universe multiverse
EOF
;;
esac

echo "I: show /etc/apt/sources.list"
cat /etc/apt/sources.list

# Fix Radxa APT Source.
# APT_REPO=("radxa")
# APT_REPO_BRANCH=("stretch-stable" "stretch-testing" "buster-stable" "buster-tesitng" "bionic-stable" "bionic-testing")
rm -rf /etc/apt/sources.list.d/apt-${APT_REPO}-com.list

if [[ "${APT_REPO}" == "radxa" ]]; then
    cat > /etc/apt/sources.list.d/apt-${APT_REPO}-com.list <<EOF
deb http://apt.${APT_REPO}.com/${SUITE}-stable/ ${SUITE} main
#deb http://apt.${APT_REPO}.com/${SUITE}-testing/ ${SUITE} main
EOF
fi

echo "I: show /etc/apt/sources.list.d/apt-${APT_REPO}-com.list"
cat /etc/apt/sources.list.d/apt-${APT_REPO}-com.list

# Add Radxa APT Source Key.
apt-key add - < /etc/apt/sources.list.d/apt-${APT_REPO}-com.key
rm -rf /etc/apt/sources.list.d/apt-${APT_REPO}-com.key
