#!/usr/bin/env bash

cd $CERTS_DIR

FILES=$(ls *.pem)

for FILE in $FILES
do
  TYPE=$(echo $FILE | awk 'BEGIN { FS = "_" } ; { print $1 }')
  HOST=$(echo $FILE | sed "s/^${TYPE}_//" | sed "s/\.pem$//" )

  echo "Store $FILE to $VAULT_PATH/$HOST/$TYPE"
  cat $FILE | vault write $VAULT_PATH/$HOST/$TYPE value=-
done
