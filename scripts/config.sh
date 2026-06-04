# Use the absolute path
ROOT_DIR="/opt/swarm-artifacts"
BIN_DIR="${ROOT_DIR}"/bin
LOG_DIR="${ROOT_DIR}"/logs
WORKLOAD_DIR="${ROOT_DIR}"/workloads
YCSB_BIN="${ROOT_DIR}"/YCSB/bin/ycsb.sh

TMUX_SESSION=oops

FIRST_MACHINE=1
FIRST_SERVER=$FIRST_MACHINE
SERVER_MACHINES=3
FIRST_CLIENT=$(($FIRST_MACHINE + $SERVER_MACHINES))
CLIENT_MACHINES=8
MACHINE_COUNT=$(($SERVER_MACHINES + $CLIENT_MACHINES))
REGISTRY_MACHINE=machine1

# Set ssh names of the machines. Should be the same for the gateway and for 
# the servers/clients
for i in $(seq 1 30); do
  declare "machine${i}=node${i}"
done

# Set fqdn names of the machines (use `hostname -f`)

for i in $(seq 1 30); do
  declare "machine${i}hostname=$(eval echo \${machine${i}})"
done

# Memcached does not run with root access
#PONY_HAVE_SUDO_ACCESS=false
#PONY_SUDO_ASKS_PASS=false
#PONY_SUDO_PASS="MyPass"

# Do not edit below this line
machine2ssh () {
    local m=$1
    echo "${!m}"
}

machine2hostname () {
    local m=$1
    local m_hn=${m}hostname
    echo "${!m_hn}"
}

export DORY_REGISTRY_IP=$(machine2hostname $REGISTRY_MACHINE)
