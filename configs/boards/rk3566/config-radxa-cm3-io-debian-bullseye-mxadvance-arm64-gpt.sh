#!/bin/bash

CMD=`realpath $0`
CONFIG_BOARD_DIR=`dirname $CMD`
TOP_DIR=$(realpath $CONFIG_BOARD_DIR/../../../)
echo "TOP DIR = $TOP_DIR"
BUILD_DIR=$TOP_DIR/build
[[ ! -d "$BUILD_DIR" ]] && mkdir -p $BUILD_DIR

# env
export CPU=rk3566
export BOARD=radxa-cm3-io
export MODEL=debian
export DISTRO=bullseye
export VARIANT=mxadvance
export ARCH=arm64
export FORMAT=gpt
export IMAGESIZE=2048MB

# Add pre-installed kernel for target system
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-kernel.list <<EOF
linux-headers-4.19.193-1-rk356x*.deb
linux-image-4.19.193-1-rk356x*.deb
EOF

# Add pre-installed packages for target system
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-packages.list <<EOF
rockchip-adbd*.deb
EOF

# Add yaml variable
cat > $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-variable.yaml <<EOF
{{- \$cpu := or .cpu "${CPU}" -}}
{{- \$board := or .board "${BOARD}" -}}
{{- \$architecture := or .architecture "${ARCH}" -}}
{{- \$model :=  or .model "${MODEL}" -}}
{{- \$suite := or  .suite "${DISTRO}" -}}
{{- \$imagesize := or .imagesize "${IMAGESIZE}" -}}
{{- \$bootpartitionend := or .bootpartitionend "294912S" -}}
{{- \$rootpartitionstart := or .rootpartitionstart "294913S" -}}
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
21_packages_devel.yaml
21_packages_kernel_cm3.yaml
21_packages_libs.yaml
21_packages_python_debian.yaml
21_packages_libv4l.yaml
21_packages_math.yaml
21_packages_mpp.yaml
21_packages_mpv.yaml
21_packages_utilities.yaml
21_packages_net.yaml
21_packages_wifibt.yaml
22_packages_end.yaml
70_system_common_setup.yaml
85_u_boot_rk35xx.yaml
90_clean_rootfs.yaml
EOF
