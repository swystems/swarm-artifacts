#!/bin/bash
set -e

source scripts/config.sh


BASE_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"

cd "$BASE_DIR"

for ((nodeid=1; nodeid<=MACHINE_COUNT; nodeid++)); do
  # ssh node$i "cd \"$BASE_DIR\"; rm -rf logs.zip; zip -r logs.zip logs/"
  # scp node$i:"$BASE_DIR/logs.zip" node$i-logs.zip
  # unzip -o node$i-logs.zip
  # rm -rf node?-logs.zip
  rsync -av --progress "node$nodeid":"$BASE_DIR/logs/*" logs/
done
