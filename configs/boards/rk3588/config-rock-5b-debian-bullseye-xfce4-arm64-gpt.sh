#!/bin/bash

CMD=`realpath $0`
CONFIG_BOARD_DIR=`dirname $CMD`
TOP_DIR=$(realpath $CONFIG_BOARD_DIR/../../../)
echo "TOP DIR = $TOP_DIR"
BUILD_DIR=$TOP_DIR/build
[[ ! -d "$BUILD_DIR" ]] && mkdir -p $BUILD_DIR

# env
export CPU=rk3588
export BOARD=rock-5b
export MODEL=debian
export DISTRO=bullseye
export VARIANT=xfce4
export ARCH=arm64
export FORMAT=gpt
export IMAGESIZE=3000MB

# Add pre-installed packages for target system
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-packages.list <<EOF
rockchip-overlay*.deb
linux-headers-5.10.66*.deb
linux-image-5.10.66*.deb
intel-wifibt-firmware*.deb
realtek-wifibt-firmware*.deb
resize-assistant*.deb
librga2_2.2.0-1_arm64.deb
librga2-dbgsym_2.2.0-1_arm64.deb
librga-dev_2.2.0-1_arm64.deb
librockchip-mpp-dev_1.5.0-1_arm64.deb
librockchip-mpp1-dbgsym_1.5.0-1_arm64.deb
librockchip-mpp1_1.5.0-1_arm64.deb
librockchip-vpu0-dbgsym_1.5.0-1_arm64.deb
librockchip-vpu0_1.5.0-1_arm64.deb
rockchip-mpp-demos-dbgsym_1.5.0-1_arm64.deb
rockchip-mpp-demos_1.5.0-1_arm64.deb
EOF

# Add yaml variable
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-variable.yaml <<EOF
{{- \$board := or .board "${BOARD}" -}}
{{- \$architecture := or .architecture "${ARCH}" -}}
{{- \$model :=  or .model "${MODEL}" -}}
{{- \$suite := or  .suite "${DISTRO}" -}}
{{- \$imagesize := or .imagesize "${IMAGESIZE}" -}}
{{- \$bootpartitionend := or .bootpartitionend "1081343S" -}}
{{- \$rootpartitionstart := or .rootpartitionstart "1081344S" -}}
{{- \$apt_repo := or .apt_repo "radxa" -}}

EOF

# Add images yaml
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-yaml.list <<EOF
00_architecture.yaml
01_debootstrap_debian.yaml
02_partitions_upstream.yaml
03_filesystem_deploy.yaml
20_packages_start.yaml
21_packages_base.yaml
21_packages_bluetooth.yaml
21_packages_devel.yaml
21_packages_libs_debian_bullseye.yaml
21_packages_math.yaml
21_packages_mpv.yaml
21_packages_sound.yaml
21_packages_utilities.yaml
21_packages_net.yaml
21_packages_xfce.yaml
21_packages_web.yaml
22_packages_end.yaml
30_overlays.yaml
60_setup_user.yaml
61_add_apt_sources.yaml
62_fix_resolv_conf.yaml
63_setup_hostname_hosts.yaml
80_preinstall_tb_packages.yaml
84_preinstall_u-boot.yaml
85_u_boot_rk35xx.yaml
90_clean_rootfs.yaml
EOF
