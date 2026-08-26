#!/bin/bash

set -u


NCLIENTS=16
NSERVERS=3
MAJORITY=2

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"

## NOTE: g=false --in-place=false is the "DM-ABD" version of the protocol.
## we want in-place writes to be faithful to the main paper text

## value scale. commpass max is 504
# for VAL in 8 16 64 128 504; do
for VAL in 64 128 504; do
    "$SCRIPT_DIR"/run.sh swarmkv \
    commpass/a-${VAL} \
    commpass/a-${VAL} \
    $NSERVERS $NCLIENTS -m $MAJORITY -d=true -g=false -v $VAL
    
    "$SCRIPT_DIR"/run.sh swarmkv \
    commpass/b-${VAL} \
    commpass/b-${VAL} \
    $NSERVERS $NCLIENTS -m $MAJORITY -d=true -g=false -v $VAL
done

## server scale
# for NS in 5 7; do
#     MAJORITY=$((NS/2 + 1))
#     "$SCRIPT_DIR"/run.sh swarmkv \
#     commpass/a-64-${NS}s \
#     commpass/a-64-${NS}s \
#     $NS $NCLIENTS -m $MAJORITY -d=true -g=false --in_place=false
    
#     "$SCRIPT_DIR"/run.sh swarmkv \
#     commpass/b-64-${NS}s \
#     commpass/b-64-${NS}s \
#     $NS $NCLIENTS -m $MAJORITY -d=true -g=false --in_place=false  
# done
