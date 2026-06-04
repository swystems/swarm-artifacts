# Reproduce swarm on cloudlab r320
Quick guide to deploy & test swarm on CloudLab, always refer to README for full 
details. 

## Use pre-configured cloudlab profile

If you have a CloudLab account, instantiate a pre-configured cluster through the 
following profile:

https://www.cloudlab.us/p/xdp-bypass23/swarm-cluster-test


### Setup cloud lab addresses

Map cloudlab nodes addresses to `~/.ssh/config`. Example for 2 
nodes below. It's important that the name stay node1, node2... nodeN because
cloudlab instances use the same names.Machines are defined in `scripts/config.sh`
which is used in a number of scripts and by the main bin. Extend `scripts/config.sh`
if you need more nodes.

```sh
 cat ~/.ssh/config

Host node9
    HostName apt136.apt.emulab.net
    User myuser

Host node10
    HostName apt130.apt.emulab.net
    User muser

```

## DIY

Spin a cloudlab small-lan with r320 nodes with Ubuntu 24.04. from the APT 
cluster (as of 05/2026). Any other machine which supports infiniband (mandatory 
requirement) should be fine. 

Install on cluster machines: 

```sh 
sudo apt update && sudo apt upgrade -y
sudo apt install -y coreutils gawk python3 python3-venv zip tmux gcc numactl libmemcached-dev memcached openjdk-8-jre-headless build-essential cmake ninja-build git libssl-dev libmemcached-dev     
```

Conan package manager:
```sh
python3 -m venv ~/.venv/conan-env
source ~/.venv/conan-env/bin/activate
pip install --upgrade "conan>=1.63.0,<2.0.0"
```

Install libibverbs (OFED not supported on r320 NICs)
```sh
sudo apt install -y libibverbs-dev
```

Clone the repo to `/opt` (useful if you want to save the CloudLab image, /home 
cannot be saved)
```sh
cd /opt/
sudo chown $USER .
git clone https://github.com/swystems/swarm-artifacts
cd swarm-artifacts
```

Setup ycsb and put swarm bin in right folder
```sh
./download-ycsb.sh
tar xf ycsb-0.12.0.tar.gz
mv ycsb-0.12.0 YCSB
mv bin/swarm-kv/swarm-kv/build/bin/swarmkv bin/
```

Run the latency benchmark:
```sh
./experiments/test-lat.sh
./gather-logs.sh
cat logs/fig5*/<some-other-folders>/client1.txt 
```

If you get some funky error make sure memcached service is stopped! 
```sh
systemctl stop memcached
```

## Other commands and info

Manual server command
```sh
source "/opt/swarm-artifacts/scripts/config.sh" 
mkdir -p /opt/swarm-artifacts/logs/fig5-latency-cdf/workload-A/SWARM-KV/ 

sudo stdbuf -o L -e L \
numactl -m 0 -N 0 -C 0 \
/opt/swarm-artifacts/bin/swarmkv -i 1 -y /opt/swarm-artifacts/YCSB/bin/ycsb.sh -w /opt/swarm-artifacts/workloads/oops-workloada -s 2 -c 4 -m 2 -T 0 -d=true 2>&1 | tee /opt/swarm-artifacts/logs/fig5-latency-cdf/workload-A/SWARM-KV/server1.txt 
sleep 10
```