#!/bin/bash

set -u

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )"/../scripts )"
"$SCRIPT_DIR"/run.sh swarmkv fig5-latency-cdf/workload-A/SWARM-KV oops-workloada 1 1 -m 1 -T 0 -d=true