#!/bin/bash

CMD=`realpath $0`
SCRIPTS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $SCRIPTS_DIR/..)
echo "TOP DIR = $TOP_DIR"

board_list=("radxa-cm3-io" "radxa-e23" "radxa-e25" "radxa-nx5" "radxa-zero" "radxa-zero2" "rockpi-4b" "rock-4c-plus" "rock-3a" "rock-3b" "rock-3c" "rock-5a" "rock-5b" )
model_list=("debian" "ubuntu")
variant_list=("xfce4" "server")

usage() {
    echo "====USAGE: $0 -b <board> -m <model> -v <variant>===="

    echo "Board list:"
    for board in ${board_list[@]}
    do
        echo "    $board"
    done

    echo " "
    echo "Model list:"
    for model in ${model_list[@]}
    do
        echo "    $model"
    done

    echo " "
    echo "Variant list:"
    for variant in ${variant_list[@]}
    do
        echo "    $variant"
    done
}

while getopts "b:m:v:h" flag; do
    case $flag in
        b)
            BOARD="$OPTARG"
            ;;
        m)
            MODEL="$OPTARG"
            ;;
        v)
            VARIANT="$OPTARG"
	esac
done

if [ ! $BOARD ] && [ ! $MODEL ]; then
    usage
    exit 1
fi

case $BOARD in
    rockpi-4b|rock-4c-plus)
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
            a311d|rk3399|rk3566|rk3568|rk3588s|rk3588|s905y2)
                DISTRO="bullseye"
                ;;
            *)
                DISTRO="buster"
                ;;
        esac
        ;;
    ubuntu)
        DISTRO="focal"
        ;;
    *)
        echo "Unsupported model $MODEL!"
        exit 4
        ;;
esac

$SCRIPTS_DIR/build.sh -c $CPU -b $BOARD -m $MODEL -d $DISTRO -v $VARIANT -a $ARCH -f $FORMAT -0
