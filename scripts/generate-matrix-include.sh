#!/bin/bash

CMD=`realpath $0`
SCRIPTS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $SCRIPTS_DIR/..)
CONFIG_BOARDS_DIR=$TOP_DIR/configs/boards

usage() {
    echo "====USAGE: $0 -b <boards> -m <models> -v <variants> ===="
}

while getopts "b:m:v:h" flag; do
    case $flag in
        b)
            IFS=',' read -ra BOARDS <<< "$OPTARG"
            ;;
        m)
            IFS=',' read -ra MODELS <<< "$OPTARG"
            ;;
        v)
            IFS=',' read -ra VARIANTS <<< "$OPTARG"
	esac
done

if [ -z $BOARDS ] || [ -z $MODELS ] || [ -z $VARIANTS ]; then
    usage
    exit 1
fi

BOARD_CONFIGS=""
for board in "${BOARDS[@]}"; do
  for model in "${MODELS[@]}"; do
    for variant in "${VARIANTS[@]}"; do
      if [ $(find $CONFIG_BOARDS_DIR -name "config-*" -name "*.sh" -name "*$board*" -name "*$model*" -name "*$variant*" | wc -l) -gt 0 ]; then
        if [ ${#BOARD_CONFIGS} -gt 0 ]; then
          BOARD_CONFIGS="$BOARD_CONFIGS,"
        fi
        BOARD_CONFIGS="$BOARD_CONFIGS{\"BOARD\":\"$board\",\"MODEL\":\"$model\",\"VARIANT\":\"$variant\"}"
      fi
    done
  done
done

echo "combinations=[$BOARD_CONFIGS]"
