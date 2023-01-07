#!/bin/bash

CMD=`realpath $0`
SCRIPTS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $SCRIPTS_DIR/..)
echo "TOP DIR = $TOP_DIR"
BUILD_DIR=$TOP_DIR/build
ROOTFS_DIR=$TOP_DIR/rootfs

OUTPUT_DIR=$TOP_DIR/output
[[ ! -d "$TOP_DIR/output" ]] && mkdir -p $TOP_DIR/output
rm -rf $OUTPUT_DIR/*.img

usage() {
    echo "====USAGE: debos-target-board.sh -c <cpu> - b <board> -m <model> -d <distro>  -v <variant> -a <arch> -f <format> [-0]===="
    echo "Specify -0 to disable debug-shell, useful for automated build."
    echo "debos-target-board..sh -c rk3568 -b rock-3a -m debian -d buster -v xfce4 -a arm64 -f gpt"
}

DEBUG_SHELL=--debug-shell

while getopts "c:b:m:d:a:v:f:h:0" flag; do
    case $flag in
        c)
            CPU="$OPTARG"
            ;;
        b)
            BOARD="$OPTARG"
            ;;
        m)
            MODEL="$OPTARG"
            ;;
        d)
            DISTRO="$OPTARG"
            ;;
        a)
            ARCH="$OPTARG"
            ;;
        v)
            VARIANT="$OPTARG"
            ;;
        f)
            FORMAT="$OPTARG"
            ;;
        0)
            DEBUG_SHELL=
            ;;
	esac
done

if [ ! $CPU ] && [ ! $BOARD ] && [ ! $MODEL ] && [ ! $DISTRO ] && [ ! $ARCH ] && [ ! $VARIANT ] && [ ! $FORMAT ]; then
    usage
    exit
fi

prepare_build() {
    echo "====Start to preppare workspace directory, build===="
    cp -av $TOP_DIR/rootfs/fs-overlay/common/overlays/* $BUILD_DIR/overlays
    cp -av $TOP_DIR/rootfs/fs-overlay/${CPU}/overlays/* $BUILD_DIR/overlays
    if [ -d $TOP_DIR/rootfs/fs-overlay/${BOARD}/overlays/ ]
    then
        cp -av $TOP_DIR/rootfs/fs-overlay/${BOARD}/overlays/* $BUILD_DIR/overlays
    fi

    cp -av $ROOTFS_DIR/recipes/*.yaml $BUILD_DIR/recipes/
    cp -av $ROOTFS_DIR/scripts/*.sh $BUILD_DIR/scripts/

    # Kernel packages
    cp -av ${BUILD_DIR}/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-kernel.list ${BUILD_DIR}/overlays/packages/kernel-packages.list
    echo "${BOARD}-${MODEL}-${DISTRO}-${ARCH}-${VARIANT}-${FORMAT}-kernel.list"
    cat $BUILD_DIR/overlays/packages/kernel-packages.list

    for pkg in `cat $BUILD_DIR/overlays/packages/kernel-packages.list`
    do
        cp -av `find $ROOTFS_DIR/packages/${ARCH} -name "$pkg"` $BUILD_DIR/overlays/packages/
    done

    # Preinstall Packages
    cp -av ${BUILD_DIR}/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-packages.list ${BUILD_DIR}/overlays/packages/preinstall-packages.list
    echo "${BOARD}-${MODEL}-${DISTRO}-${ARCH}-${VARIANT}-${FORMAT}-packages.list"
    cat $BUILD_DIR/overlays/packages/preinstall-packages.list

    for pkg in `cat $BUILD_DIR/overlays/packages/preinstall-packages.list`
    do
        cp -av `find $ROOTFS_DIR/packages/${ARCH} -name "$pkg"` $BUILD_DIR/overlays/packages/
    done

    cp -av `find $ROOTFS_DIR/packages/$ARCH -name "*$BOARD*"` $BUILD_DIR/overlays/packages/
    echo "====Preparing workspace directory, build is done===="
}

generate_target_yaml() {
    echo "====Start to generate $BOARD-$MODEL-$DISTRO-$VARIANT-$ARCH-$FORMAT yaml===="
    TARGET_YAML=$BUILD_DIR/$BOARD-$MODEL-$DISTRO-$VARIANT-$ARCH-$FORMAT.yaml
    touch ${TARGET_YAML}
    TEMP_YAML_DIR=$BUILD_DIR/temp_yaml
    [ ! -d $TEMP_YAML_DIR ] && mkdir $TEMP_YAML_DIR

    for yaml in `cat $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-yaml.list`
    do
        cp -f $BUILD_DIR/recipes/$yaml $TEMP_YAML_DIR 2>/dev/null
    done

    cd $TEMP_YAML_DIR
    cat $BUILD_DIR/${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${FORMAT}-variable.yaml >> $TARGET_YAML
    for yaml in `ls | sort -n`
    do
        cat $yaml >> $TARGET_YAML
    done
    echo "====$BOARD-$MODEL-$DISTRO-$VARIANT-$ARCH-$FORMAT yaml is ready===="
}

debos_system_image() {
    echo "====debos $BOARD-$MODEL-$DISTRO-$VARIANT-$ARCH-$FORMAT start===="
    cd $OUTPUT_DIR && debos --memory=4096MB --cpus=10  --print-recipe --show-boot -v $DEBUG_SHELL $TARGET_YAML
    echo "====debos $BOARD-$MODEL-$DISTRO-$VARIANT-$ARCH-$FORMAT end===="
}

prepare_build
generate_target_yaml
debos_system_image
