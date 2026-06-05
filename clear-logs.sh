#!/bin/bash
set -e

source scripts/config.sh


BASE_DIR="$( realpath -sm  "$( dirname "${BASH_SOURCE[0]}" )")"

cd "$BASE_DIR"

for ((nodeid=1; nodeid<=MACHINE_COUNT; nodeid++)); do
  ssh node$nodeid "cd \"$BASE_DIR\"; rm -rf logs/*"
done
