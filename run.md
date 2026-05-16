# Reproduce swarm on cloudlab r320

follow README

install on cluster machines: 

```sh 
sudo apt update && sudo apt upgrade
sudo apt install -y coreutils gawk python3-pip zip tmux gcc numactl libmemcached-dev memcached openjdk-8-jre-headless build-essential cmake ninja-build git libssl-dev libmemcached-dev     
```

```sh
pip install "conan>=1.63.0,<2.0.0"
pipx ensurepath
```

Install libibverbs (OFED not supported on r320 NICs)

```sh
sudo apt install libibverbs-dev
```

Add self among RDMA users

```sh
sudo usermod -aG rdma $USER
```

```sh
git clone https://github.com/swystems/swarm-artifacts --recurse-submodules
cd swarm-artifacts
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