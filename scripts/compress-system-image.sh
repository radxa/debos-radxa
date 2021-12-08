#!/bin/bash

CMD=`realpath $0`
SCRIPTS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $SCRIPTS_DIR/..)
echo "TOP DIR = $TOP_DIR"

OUTPUT_DIR=$TOP_DIR/output
[[ ! -d "$TOP_DIR/output" ]] && mkdir -p $TOP_DIR/output

usage() {
    echo "====USAGE: compress-system-image.sh -c <cpu> - b <board> -m <model> -d <distro>  -v <variant> -a <arch> -f <format>===="
    echo "compress-system-image.sh -c rk3568 -b rock-3a -m debian -d buster -v xfce4 -a arm64 -f gpt"
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

if [ ! $CPU ] && [ ! $BOARD ] && [ ! $MODEL ] && [ ! $DISTRO ] && [ ! $ARCH ] && [ ! $VARIANT ] && [ ! $FORMAT ]; then
    usage
    exit
fi

cd $OUTPUT_DIR
if [[ -e "system.img" ]]; then
    TIME=$(date +%Y%m%d-%H%M)
    mv "system.img" "${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${TIME}-${FORMAT}.img"
    md5sum "${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${TIME}-${FORMAT}.img" > "${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${TIME}-${FORMAT}.img.md5.txt"
    bmaptool create "${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${TIME}-${FORMAT}.img" > "${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${TIME}-${FORMAT}.img.bmap"
    gzip -f "${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${TIME}-${FORMAT}.img"
fi

echo -e  "\e[36m System image ${BOARD}-${MODEL}-${DISTRO}-${VARIANT}-${ARCH}-${TIME}-${FORMAT}.img is generated. See it in $OUTPUT_DIR \e[0m"
cd -
