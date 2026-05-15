# Reproduce swarm on cloudlab r320

follow README

Add self among RDMA users

```sh
sudo usermod -aG rdma $USER
```

move local repo and remote folders to `/opt/` so that you can create a persistent cloudlab image later.

make sure vm names are the _same_: use h=same hostname for gateway/local config and remote cluster 

stop memcached service! 

Manual server command
```sh
source "/opt/swarm-artifacts/scripts/config.sh" 
mkdir -p /opt/swarm-artifacts/logs/fig5-latency-cdf/workload-A/SWARM-KV/ 

stdbuf -o L -e L \
numactl -m 0 -N 0 -C 0 \
/opt/swarm-artifacts/bin/swarmkv -i 1 -y /opt/swarm-artifacts/YCSB/bin/ycsb.sh -w /opt/swarm-artifacts/workloads/oops-workloada -s 2 -c 4 -m 2 -T 0 -d=true 2>&1 | tee /opt/swarm-artifacts/logs/fig5-latency-cdf/workload-A/SWARM-KV/server1.txt 
sleep 10
```