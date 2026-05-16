#!/bin/bash
source scripts/config.sh

# nodes=(node0 node1 node2)

for ((nodeid=0; nodeid<MACHINE_COUNT; nodeid++)); do
  node=$(machine2ssh "machine$((nodeid + 1))")
  rsync -av scripts/ "$node":/opt/swarm-artifacts/scripts/
done
