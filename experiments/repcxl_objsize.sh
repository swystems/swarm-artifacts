#!/bin/bash

set -u

## 9 is the repcxl setting but crashes bc of some core affinity settings
## clients are assigned round robin to client machines in config.sh
NCLIENTS=8
NSERVERS=3
MAJORITY=2

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"



for SIZE in {16,128,1024}; do
    "$SCRIPT_DIR"/run.sh swarmkv objsize-ycsba/${SIZE}B oops-workloada-$SIZE $NSERVERS $NCLIENTS -m $MAJORITY -T 0 -d=true -v $SIZE
    "$SCRIPT_DIR"/run.sh swarmkv objsize-ycsbb/${SIZE}B oops-workloadb-$SIZE $NSERVERS $NCLIENTS -m $MAJORITY -T 0 -d=true -v $SIZE
    # "$SCRIPT_DIR"/run.sh swarmkv fig9-value-sizes/workload-A/SWARM-KV/Out-P/values-of-${SIZE}B oops-workloada-$SIZE 2 4 -m 2 -T 0 --in_place=false -d=true -v $SIZE
    # "$SCRIPT_DIR"/run.sh swarmkv fig9-value-sizes/workload-B/SWARM-KV/Out-P/values-of-${SIZE}B oops-workloadb-$SIZE 2 4 -m 2 -T 0 --in_place=false -d=true -v $SIZE
done


for SIZE in {4096,8192}; do
    "$SCRIPT_DIR"/run.sh swarmkv objsize-ycsba/${SIZE}B oops-workloada-$SIZE $NSERVERS $NCLIENTS -m $MAJORITY -T 0 -d=true -v $SIZE -I 200000
    "$SCRIPT_DIR"/run.sh swarmkv objsize-ycsbb/${SIZE}B oops-workloadb-$SIZE $NSERVERS $NCLIENTS -m $MAJORITY -T 0 -d=true -v $SIZE -I 200000
done