#!/bin/bash

CMD=`realpath $0`
SCRIPTS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $SCRIPTS_DIR/..)
echo "TOP DIR = $TOP_DIR"

usage() {
    echo "====USAGE: $0 -b <board> -m <model>===="
    echo "Options:"
    echo "  ./$0 -b radxa-cm3-io -m debian"
    echo "  ./$0 -b radxa-cm3-io -m ubuntu"
    echo "  ./$0 -b radxa-e23 -m debian"
    echo "  ./$0 -b radxa-e23 -m ubuntu"
    echo "  ./$0 -b radxa-e25 -m debian"
    echo "  ./$0 -b radxa-e25 -m ubuntu"
    echo "  ./$0 -b radxa-nx5 -m debian"
    echo "  ./$0 -b radxa-nx5 -m ubuntu"
    echo "  ./$0 -b radxa-zero -m debian"
    echo "  ./$0 -b radxa-zero -m ubuntu"
    echo "  ./$0 -b radxa-zero2 -m debian"
    echo "  ./$0 -b radxa-zero2 -m ubuntu"
    echo "  ./$0 -b rockpi-4b -m debian"
    echo "  ./$0 -b rockpi-4b -m ubuntu"
    echo "  ./$0 -b rockpi-4cplus -m debian"
    echo "  ./$0 -b rockpi-4cplus -m ubuntu"
    echo "  ./$0 -b rockpi-s -m debian"
    echo "  ./$0 -b rockpi-s -m ubuntu"
    echo "  ./$0 -b rock-3a -m debian"
    echo "  ./$0 -b rock-3a -m ubuntu"
    echo "  ./$0 -b rock-3b -m debian"
    echo "  ./$0 -b rock-3b -m ubuntu"
    echo "  ./$0 -b rock-3c -m debian"
    echo "  ./$0 -b rock-3c -m ubuntu"
    echo "  ./$0 -b rock-5a -m debian"
    echo "  ./$0 -b rock-5a -m ubuntu"
    echo "  ./$0 -b rock-5b -m debian"
    echo "  ./$0 -b rock-5b -m ubuntu"
}

while getopts "b:m:h" flag; do
    case $flag in
        b)
            BOARD="$OPTARG"
            ;;
        m)
            MODEL="$OPTARG"
            ;;
	esac
done

if [ ! $BOARD ] && [ ! $MODEL ]; then
    usage
    exit 1
fi

case $BOARD in
    rockpi-4b|rockpi-4cplus)
        CPU="rk3399"
        ;;
    radxa-cm3-io|radxa-e23|rock-3c)
        CPU="rk3566"
        ;;
    radxa-e25|rock-3a|rock-3b)
        CPU="rk3568"
        ;;
    radxa-nx5|rock-5a)
        CPU="rk3588s"
        ;;
    rock-5b)
        CPU="rk3588"
        ;;
    radxa-zero)
        CPU="s905y2"
        ;;
    radxa-zero2)
        CPU="a311d"
        ;;
    rockpi-s)
        CPU="rk3308"
        ;;
    *)
        echo "Unsupported board $BOARD!"
        exit 2
        ;;
esac

case $CPU in
    rk3308|rk3399|rk3566|rk3568|rk3588s|rk3588)
        ARCH="arm64"
        FORMAT="gpt"
        ;;
    s905y2|a311d)
        ARCH="arm64"
        FORMAT="mbr"
        ;;
    *)
        echo "Unsupported cpu $CPU!"
        exit 3
        ;;
esac

case $MODEL in
    debian)
        case $CPU in
            rk3399|rk3566|rk3568|rk3588s|rk3588)
                DISTRO="bullseye"
                ;;
            *)
                DISTRO="buster"
                ;;
        esac
        case $BOARD in
            rockpi-s)
                VARIANT="server"
                ;;
            *)
                VARIANT="xfce4"
                ;;
        esac
        ;;
    ubuntu)
        DISTRO="focal"
        VARIANT="server"
        ;;
    *)
        echo "Unsupported model $MODEL!"
        exit 4
        ;;
esac

./build.sh -c $CPU -b $BOARD -m $MODEL -d $DISTRO -v $VARIANT -a $ARCH -f $FORMAT -0
