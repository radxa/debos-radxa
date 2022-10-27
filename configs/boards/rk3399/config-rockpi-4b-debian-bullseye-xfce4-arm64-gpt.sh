#!/bin/bash

CMD=`realpath $0`
CONFIG_BOARD_DIR=`dirname $CMD`
TOP_DIR=$(realpath $CONFIG_BOARD_DIR/../../../)
echo "TOP DIR = $TOP_DIR"
BUILD_DIR=$TOP_DIR/build
[[ ! -d "$BUILD_DIR" ]] && mkdir -p $BUILD_DIR

# env
export CPU=rk3399
export BOARD=rockpi-4b
export MODEL=debian
export DISTRO=bullseye
export VARIANT=xfce4
export ARCH=arm64
export FORMAT=gpt
export IMAGESIZE=4000MB

# Add pre-installed packages for target system
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-packages.list <<EOF
linux-headers-4.4.194-*-rk3399-rockchip*.deb
linux-image-4.4.194-*-rk3399-rockchip*.deb
linux-firmware-image-4.4.194-*-rk3399-rockchip*.deb
rockpi4-dtbo*.deb
librga2_2.1.0-1_arm64.deb
librga-dev_2.1.0-1_arm64.deb
librga2-dbgsym_2.1.0-1_arm64.deb
rockchip-overlay*all.deb
dvb-tools-dbgsym_1.20.0-2_arm64.deb
libv4l-rkmpp-dbgsym_1.4.0-1_arm64.deb
dvb-tools_1.20.0-2_arm64.deb
libv4l-rkmpp_1.4.0-1_arm64.deb
ir-keytable-dbgsym_1.20.0-2_arm64.deb
libv4l2rds0-dbgsym_1.20.0-2_arm64.deb
ir-keytable_1.20.0-2_arm64.deb
libv4l2rds0_1.20.0-2_arm64.deb
libdvbv5-0-dbgsym_1.20.0-2_arm64.deb
libv4lconvert0-dbgsym_1.20.0-2_arm64.deb
libdvbv5-0_1.20.0-2_arm64.deb
libv4lconvert0_1.20.0-2_arm64.deb
libdvbv5-dev_1.20.0-2_arm64.deb
qv4l2-dbgsym_1.20.0-2_arm64.deb
libdvbv5-doc_1.20.0-2_all.deb
qv4l2_1.20.0-2_arm64.deb
libv4l-0-dbgsym_1.20.0-2_arm64.deb
v4l-utils-dbgsym_1.20.0-2_arm64.deb
libv4l-0_1.20.0-2_arm64.deb
v4l-utils_1.20.0-2_arm64.deb
libv4l-dev_1.20.0-2_arm64.deb
EOF

# Add yaml variable
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-variable.yaml <<EOF
{{- \$cpu := or .cpu "${CPU}" -}}
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
02_partitions_rockchip.yaml
03_filesystem_deploy.yaml
20_packages_start.yaml
21_packages_base.yaml
21_packages_bluetooth.yaml
21_packages_camera.yaml
21_packages_devel.yaml
21_packages_graphics.yaml
21_packages_gstreamer.yaml
21_packages_kernel.yaml
21_packages_libs.yaml
21_packages_libv4l.yaml
21_packages_math.yaml
21_packages_mpp.yaml
21_packages_mpv.yaml
21_packages_sound.yaml
21_packages_utilities.yaml
21_packages_net.yaml
21_packages_web.yaml
21_packages_wifibt.yaml
21_packages_xfce.yaml
21_packages_xserver.yaml
22_packages_end.yaml
70_system_common_setup.yaml
85_u_boot.yaml
90_clean_rootfs.yaml
EOF
