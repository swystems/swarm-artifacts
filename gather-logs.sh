#!/bin/bash
set -e

BASE_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"

cd "$BASE_DIR"

for i in {0..2}; do
  ssh node$i "cd \"$BASE_DIR\"; rm -rf logs.zip; zip -r logs.zip logs/"
  scp node$i:"$BASE_DIR/logs.zip" node$i-logs.zip
  unzip -o node$i-logs.zip
  rm -rf node?-logs.zip
done
