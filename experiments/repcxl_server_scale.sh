#!/bin/bash

set -u

## 9 is the repcxl setting but crashes bc of some core affinity settings
## clients are assigned round robin to client machines in config.sh
NCLIENTS=8
# NSERVERS=3
# MAJORITY=2

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"


for M in {7,14,21}; do
    MAJORITY=$(($M/2 + 1))
    # "$SCRIPT_DIR"/run.sh swarmkv \
    # server-scale-ycsba/${M}nodes \
    # oops-workloada \
    # $M $NCLIENTS -m $MAJORITY -T 0 -d=true

    "$SCRIPT_DIR"/run.sh swarmkv \
    server-scale-ycsba1key/${M}nodes \
    oops-workloada-singlekey \
    $M $NCLIENTS -m $MAJORITY -T 0 -d=true

done