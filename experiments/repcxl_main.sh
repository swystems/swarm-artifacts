#!/bin/bash

set -u

## 9 is the repcxl setting but crashes bc of some core affinity settings
## clients are assigned round robin to client machines in config.sh
NCLIENTS=8 
NSERVERS=3
MAJORITY=2

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

## low contention
"$SCRIPT_DIR"/run.sh swarmkv \
low-contention/ycsba \
oops-workloada \
$NSERVERS $NCLIENTS -m $MAJORITY -T 0 -d=true

"$SCRIPT_DIR"/run.sh swarmkv \
low-contention/ycsbb \
oops-workloadb \
$NSERVERS $NCLIENTS -m $MAJORITY -T 0 -d=true


# high contention = single key
"$SCRIPT_DIR"/run.sh swarmkv \
hi-contention/ycsba \
oops-workloada-singlekey \
$NSERVERS $NCLIENTS -m $MAJORITY -T 0 -d=true

"$SCRIPT_DIR"/run.sh swarmkv \
hi-contention/ycsbb \
oops-workloadb-singlekey \
$NSERVERS $NCLIENTS -m $MAJORITY -T 0 -d=true