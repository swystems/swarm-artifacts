# Reproduce swarm on cloudlab r320
Quick guide to deploy & test swarm on CloudLab, always refer to README for full 
details. 

## Use pre-configured cloudlab profile

If you have a CloudLab account, instantiate a pre-configured cluster through the 
following profile:

https://www.cloudlab.us/p/xdp-bypass23/swarm-cluster-test


### Setup cloud lab addresses
`scripts/config.sh` defines the names and setup of the nodes for the experiments.
It assumes ssh passwordless access to machines which can be configured for CloudLab
as follows: 

1. Once the CloudLab experiment has started, download/save the XML manifest into `./manifest.xml`
2. `python3 manifest_to_ssh_config.py --manifest manifest.xml > cloudlab_ssh` (double check the user is correct, otherwise specify with `--user`)
3. Add the line `Include <abs_path_to_this_repo>/cloudlab_ssh` *at the top of* 
`~/.ssh/config`.


Machines/node names are defined in  Currently `scripts/config.sh` assumes max 30 nodes, edit for more.

*Alternative manual instructions:* see example below. It's important that the name stay node1, node2... nodeN because cloudlab automatically uses that naming convention when initalizing the cluster swarm-kv instances use names (instead of addresses) to communicate with other 
instances.


```sh
 cat ~/.ssh/config

Host node9
    StrictHostKeyChecking no
    HostName apt136.apt.emulab.net
    User myuser

Host node10
    StrictHostKeyChecking no
    HostName apt130.apt.emulab.net
    User myuser

```

### Run

- Edit `scripts/config.sh` with the nuumber of clients and server machines.

```sh
## if prev expertiments were run
clear-logs.sh

## deploy config and run the repcxl_main.sh experiment
update-scripts.sh
experiments/repcxl_main.sh
gather-logs.sh
```

## DIY from clean cloulab experiment

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

### build 1 & send all

```sh
ssh node1
cd /opt/swarm-artifacts/bin/swarm-kv/swarm-kv
./build.sh swarm-kv
exit
scp /opt/swarm-artifacts/bin/swarm-kv/swarm-kv/build/bin/swarmkv .
for i in 2 3 4 5 6 7 8 9 10 11; do rsync --progress swarmkv node$i:/opt/swarm-artifacts/bin/swarmkv; done
```

### Manual server command

```sh
source "/opt/swarm-artifacts/scripts/config.sh" 
mkdir -p /opt/swarm-artifacts/logs/fig5-latency-cdf/workload-A/SWARM-KV/ 

sudo stdbuf -o L -e L \
numactl -m 0 -N 0 -C 0 \
/opt/swarm-artifacts/bin/swarmkv -i 1 -y /opt/swarm-artifacts/YCSB/bin/ycsb.sh -w /opt/swarm-artifacts/workloads/oops-workloada -s 2 -c 4 -m 2 -T 0 -d=true 2>&1 | tee /opt/swarm-artifacts/logs/fig5-latency-cdf/workload-A/SWARM-KV/server1.txt 
sleep 10
```