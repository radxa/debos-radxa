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
stretch|buster)
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

bullseye)
cat <<-EOF > /etc/apt/sources.list
deb http://${DEBIAN_MIRROR} ${SUITE} main contrib non-free
#deb-src http://${DEBIAN_MIRROR} ${SUITE} main contrib non-free

deb http://${DEBIAN_MIRROR} ${SUITE}-updates main contrib non-free
#deb-src http://${DEBIAN_MIRROR} ${SUITE}-updates main contrib non-free

deb http://${DEBIAN_MIRROR} ${SUITE}-backports main contrib non-free
#deb-src http://${DEBIAN_MIRROR} ${SUITE}-backports main contrib non-free

deb http://security.debian.org/debian-security ${SUITE}-security main contrib non-free
#deb-src http://security.debian.org/debian-security ${SUITE}-security main contrib non-free
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

