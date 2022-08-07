#!/bin/bash

CMD=`realpath $0`
CONFIG_BOARD_DIR=`dirname $CMD`
TOP_DIR=$(realpath $CONFIG_BOARD_DIR/../../../)
echo "TOP DIR = $TOP_DIR"
BUILD_DIR=$TOP_DIR/build
[[ ! -d "$BUILD_DIR" ]] && mkdir -p $BUILD_DIR

# env
export CPU=rk3568
export BOARD=rock-3b
export MODEL=debian
export DISTRO=buster
export VARIANT=xfce4
export ARCH=arm64
export FORMAT=gpt
export IMAGESIZE=3000MB

# Add pre-installed packages for target system
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-packages.list <<EOF
radxa-add-overlay*.deb
rockchip-overlay*.deb
linux-headers-4.19.193-*.deb
linux-image-4.19.193-*.deb
linux-4.19-rock-3-latest*.deb
resize-assistant*.deb
brcm-patchram-plus1*.deb
broadcom-wifibt-firmware*.deb
libmpv1_0.29.1-1_arm64.deb
libmpv1-dbgsym_0.29.1-1_arm64.deb
libmpv-dev_0.29.1-1_arm64.deb
mpv_0.29.1-1_arm64.deb
mpv-dbgsym_0.29.1-1_arm64.deb
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
21_packages_libs_debian.yaml
21_packages_math.yaml
21_packages_mpv.yaml
21_packages_sound.yaml
21_packages_utilities.yaml
21_packages_net.yaml
21_packages_xfce.yaml
21_packages_web.yaml
22_packages_end.yaml
70_system_common_setup.yaml
85_u_boot_rk35xx.yaml
90_clean_rootfs.yaml
EOF
