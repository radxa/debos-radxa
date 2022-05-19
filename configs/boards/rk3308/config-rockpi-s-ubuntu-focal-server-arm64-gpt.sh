#!/bin/bash

CMD=`realpath $0`
CONFIG_BOARD_DIR=`dirname $CMD`
TOP_DIR=$(realpath $CONFIG_BOARD_DIR/../../../)
echo "TOP DIR = $TOP_DIR"
BUILD_DIR=$TOP_DIR/build
[[ ! -d "$BUILD_DIR" ]] && mkdir -p $BUILD_DIR

# env
export CPU=rk3308
export BOARD=rockpi-s
export MODEL=ubuntu
export DISTRO=focal
export VARIANT=server
export ARCH=arm64
export FORMAT=gpt
export IMAGESIZE=950MB

# Add pre-installed packages for target system
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-packages.list <<EOF
rockchip-overlay*.deb
linux-headers-4.4.143-*.deb
linux-image-4.4.143-*.deb
linux-firmware-image-4.4.143-*.deb
linux-4.4-rock-pi-s-latest*.deb
networkmanager-patch*.deb
rtl8723ds-firmware*.deb
rockchip-adbd*.deb
resize-assistant*.deb
EOF

# Add yaml variable
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-variable.yaml <<EOF
{{- \$board := or .board "${BOARD}" -}}
{{- \$architecture := or .architecture "${ARCH}" -}}
{{- \$model :=  or .model "${MODEL}" -}}
{{- \$suite := or  .suite "${DISTRO}" -}}
{{- \$imagesize := or .imagesize "${IMAGESIZE}" -}}
{{- \$bootpartitionend := or .bootpartitionend "262143S" -}}
{{- \$rootpartitionstart := or .rootpartitionstart "262144S" -}}
{{- \$apt_repo := or .apt_repo "radxa" -}}

EOF

# Add images yaml
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-yaml.list <<EOF
00_architecture.yaml
01_debootstrap_ubuntu.yaml
02_partitions_upstream.yaml
03_filesystem_deploy.yaml
20_packages_start.yaml
21_packages_base.yaml
22_packages_end.yaml
30_overlays.yaml
60_setup_user.yaml
61_add_apt_sources.yaml
62_fix_resolv_conf.yaml
63_setup_hostname_hosts.yaml
65_fix_uenv.yaml
80_preinstall_tb_packages.yaml
84_preinstall_u-boot.yaml
80_preinstall_tb_packages.yaml
85_u_boot.yaml
90_clean_rootfs.yaml
EOF
