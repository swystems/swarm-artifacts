#!/bin/bash
source scripts/config.sh

# nodes=(node0 node1 node2)
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <user> <path>"
    exit 1
fi

for ((nodeid=FIRST_MACHINE; nodeid<FIRST_MACHINE + MACHINE_COUNT; nodeid++)); do
  node=$(machine2ssh "machine$nodeid")
  ssh $node sudo chown -R $1 $2
done
