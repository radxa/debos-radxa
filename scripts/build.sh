#!/bin/bash

CMD=`realpath $0`
SCRIPTS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $SCRIPTS_DIR/..)
echo "TOP DIR = $TOP_DIR"
BOARDS_DIR=$TOP_DIR/boards
BUILD_DIR=$TOP_DIR/build
[ ! -d "$BUILD_DIR" ] && mkdir -p $BUILD_DIR/overlays $BUILD_DIR/recipes $BUILD_DIR/scripts

cleanup() {
    rm -rf $BUILD_DIR
}
trap cleanup EXIT

usage() {
    echo "====USAGE: build.sh -c <cpu> -b <board> -m <model> -d <distro>  -v <variant> -a <arch> -f <format>===="
    echo "Options:"
    echo "  ./build.sh -c rk3566 -b radxa-e23 -m debian -d buster -v xfce4 -a arm64 -f gpt"
    echo "  ./build.sh -c rk3566 -b radxa-e23 -m ubuntu -d focal -v server -a arm64 -f gpt"
    echo "  ./build.sh -c rk3568 -b rock-3a -m debian -d buster -v xfce4 -a arm64 -f gpt"
    echo "  ./build.sh -c rk3568 -b rock-3a -m ubuntu -d focal -v server -a arm64 -f gpt"
}

while getopts "c:b:m:d:a:v:f:h" flag; do
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
	esac
done

if [ ! $CPU ] && [ ! $BOARD ] && [ ! $MODEL ] && [ ! $DISTRO ] && [ ! $VARIANT ]  && [ ! $ARCH ] && [ ! $FORMAT ]; then
    usage
    exit
fi

build_board() {
    echo "====Start to build $SUBBOARD board system image===="
    $SCRIPTS_DIR/debos-target-board.sh -c $CPU -b $BOARD -m $MODEL -d $DISTRO -v $VARIANT -a $ARCH -f $FORMAT
    $SCRIPTS_DIR/compress-system-image.sh -c $CPU -b $BOARD -m $MODEL -d $DISTRO -v $VARIANT -a $ARCH -f $FORMAT
    echo "====Building $SUBBOARD board system image is done===="
}

clean_system_images() {
    echo "====Start to clean system images===="
    $SCRIPTS_DIR/clean-system-images.sh
    echo "====Cleaning system images is done===="
}

build_board
clean_system_images
