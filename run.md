# Reproduce swarm on cloudlab r320

follow README

install on cluster machines: 

```sh 
sudo apt update && sudo apt upgrade -y
sudo apt install -y coreutils gawk python3 python3-venv zip tmux gcc numactl libmemcached-dev memcached openjdk-8-jre-headless build-essential cmake ninja-build git libssl-dev libmemcached-dev     
```

```sh
python3 -m venv ~/.venv/conan-env
source ~/.venv/conan-env/bin/activate
pip install --upgrade "conan>=1.63.0,<2.0.0"
```

Install libibverbs (OFED not supported on r320 NICs)

```sh
sudo apt install -y libibverbs-dev
```

Add self among RDMA users

```sh
sudo usermod -aG rdma $USER
```

```sh
cd /opt/
sudo chown $USER .
git clone https://github.com/swystems/swarm-artifacts
cd swarm-artifacts
```


make sure vm use same hostname for gateway/local config and remote cluster 

stop memcached service! 

Manual server command
```sh
source "/opt/swarm-artifacts/scripts/config.sh" 
mkdir -p /opt/swarm-artifacts/logs/fig5-latency-cdf/workload-A/SWARM-KV/ 

sudo stdbuf -o L -e L \
numactl -m 0 -N 0 -C 0 \
/opt/swarm-artifacts/bin/swarmkv -i 1 -y /opt/swarm-artifacts/YCSB/bin/ycsb.sh -w /opt/swarm-artifacts/workloads/oops-workloada -s 2 -c 4 -m 2 -T 0 -d=true 2>&1 | tee /opt/swarm-artifacts/logs/fig5-latency-cdf/workload-A/SWARM-KV/server1.txt 
sleep 10
```