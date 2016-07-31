#!/bin/bash

FP=$(cd ${0%/*} && pwd -P)
export VENDOR=$(basename $(dirname $FP))
export DEVICE=$(basename $FP)
export BOARDCONFIGVENDOR=true

mkdir system
sudo mount -o loop -t ext4 system.ext4 system

BASE=../../../vendor/$VENDOR/$DEVICE/proprietary
rm -rf $BASE/*

#for FILE in `grep -v ^# proprietary-files.txt | grep -v ^$ | sort`
for FILE in `grep -v ^# proprietary-files.txt | grep -v ^$`
do
  # Split the file from the destination (format is "file[:destination]")
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  FILE=${PARSING_ARRAY[0]}
  DEST=${PARSING_ARRAY[1]}
  if [ -z "$DEST" ]; then
    DEST=$FILE
  fi
  DIR=`dirname $DEST`
  if [ ! -d $BASE/$DIR ]; then
    mkdir -p $BASE/$DIR
  fi

  cp ./system/$FILE $BASE/$DEST
  # if file dot not exist try destination
  if [ "$?" != "0" ]; then
    cp ./system/$DEST $BASE/$DEST
  fi
done

sudo umount system
rm -rf system

./setup-makefiles.sh
../fusion3-common/extract-files.sh
