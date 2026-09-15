#!/bin/bash

set -u

NCLIENTS=16
NSERVERS=3
MAJORITY=2

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

## NOTE: -g=false is the "DM-ABD" version of the protocol.
## run.sh arg order: <bin> <results folder> <workload file workloads/> <servers> 
## <clients> -m <majority> -d=<true/false> -g=<true/false> --in_place=<true/false> -v <value



for VAL in 8 256 512; do
    "$SCRIPT_DIR"/run.sh swarmkv \
    commpass/a-${VAL} \
    commpass/a-${VAL} \
    $NSERVERS $NCLIENTS -m $MAJORITY -d=true -g=false --in_place=false -v $VAL
    
    "$SCRIPT_DIR"/run.sh swarmkv \
    commpass/b-${VAL} \
    commpass/b-${VAL} \
    $NSERVERS $NCLIENTS -m $MAJORITY -d=true -g=false --in_place=false -v $VAL
done

# uncomment for in-place only

# for VAL in 8 16 64 128 504; do
for VAL in 256; do
    "$SCRIPT_DIR"/run.sh swarmkv \
    commpass/a-inplace-${VAL} \
    commpass/a-${VAL} \
    $NSERVERS $NCLIENTS -m $MAJORITY -d=true -g=false -v $VAL
    
    "$SCRIPT_DIR"/run.sh swarmkv \
    commpass/b-inplace-${VAL} \
    commpass/b-${VAL} \
    $NSERVERS $NCLIENTS -m $MAJORITY -d=true -g=false -v $VAL
done
