#!/bin/bash

CMD=`realpath $0`
SCRIPTS_DIR=`dirname $CMD`
TOP_DIR=$(realpath $SCRIPTS_DIR/..)
echo "TOP DIR = $TOP_DIR"

OUTPUT_DIR=$TOP_DIR/output
[[ ! -d "$OUTPUT_DIR" ]] && exit 1

cd $OUTPUT_DIR
NAME=("*.gz" "*.bmap" "*.md5.txt")
for target in ${NAME[@]};
do
    find . -mtime +0 -name "${target}" -exec rm -f {} \;
done

echo "I: show all system images:"
ls -al $OUTPUT_DIR
