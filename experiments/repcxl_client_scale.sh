#!/bin/bash

set -u

## 9 is the repcxl setting but crashes bc of some core affinity settings
## clients are assigned round robin to client machines in config.sh
# NCLIENTS=8 
NSERVERS=3
MAJORITY=2

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"


for CLIENTS in {4,8,12,20,28,36,44,48,56,64}; do
# for CLIENTS in {36,44,48,56,64}; do
    "$SCRIPT_DIR"/run.sh swarmkv \
    client-scale-ycsba/${CLIENTS}clients \
    oops-workloada \
    $NSERVERS $CLIENTS -m $MAJORITY -T 0 -d=true
done