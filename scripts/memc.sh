#!/bin/bash

set -e

SCRIPT_DIR="$( realpath -sm "$( dirname "${BASH_SOURCE[0]}" )" )"
source "$SCRIPT_DIR"/config.sh

tmux new-session -d -s $TMUX_SESSION &>/dev/null || true
tmux new-window -t $TMUX_SESSION -n "memc" \
"sudo systemctl stop memcached; killall memcached; LD_PRELOAD=$SCRIPT_DIR/libreparent.so memcached"
