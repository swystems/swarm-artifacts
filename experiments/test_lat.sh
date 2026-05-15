#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"
"$SCRIPT_DIR"/run.sh swarmkv fig5-latency-cdf/workload-A/SWARM-KV oops-workloada 2 1 -m 2 -T 0 -d=true


