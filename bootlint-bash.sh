#!/bin/bash
#set -o nounset
#set -o errexit

START=$(date +"%s")
FILE=bootlint-`date '+%Y-%m-%d_%H.%M.%S'`.txt

LOCAL_ROOT=`pwd`
CAPTURE_DIR=output

# make dir if it doesn't exist
if [ ! -d "$LOCAL_ROOT/$CAPTURE_DIR" ]; then
  mkdir "$LOCAL_ROOT/$CAPTURE_DIR"
fi

# append a line return to make sure last line is processed
sed -i '' -e '$a\' $1

while read line; do
    echo URL: "$line"
    curl "$line" | bootlint
done < $1 >> "$LOCAL_ROOT/$CAPTURE_DIR/$FILE"

echo -e "Bootlint errors: "
cat "$LOCAL_ROOT/$CAPTURE_DIR/$FILE" | grep "<stdin>" | wc -l

END=$(date +"%s")
DIFF=$(($END-$START))

echo -e "Reports took $(($DIFF / 60))min $(($DIFF % 60))sec"
