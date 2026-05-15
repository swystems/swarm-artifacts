#!/bin/bash

nodes=(node0 node1 node2)

for node in "${nodes[@]}"; do
  rsync -av scripts/ "$node":/opt/swarm-artifacts/scripts/
done
