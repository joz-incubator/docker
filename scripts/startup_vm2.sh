#!/bin/bash

# Update OS and install Docker
apt update && apt full-upgrade -y
apt install -y docker.io

# Ensure Docker is up to date
apt install --only-upgrade -y docker.io

# Start Docker
systemctl start docker

# Detect primary network interface (excluding loopback and docker interfaces)
PARENT_IF=$(ip -o -4 route show to default | awk '{print $5}')

# Enable forwarding
sysctl -w net.ipv4.ip_forward=1

# Disable strict reverse-path filtering
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.rp_filter=0

# create interface and gateway for local containers
ip link add ipvlan link $PARENT_IF type ipvlan mode l3
ip addr add 192.168.200.1/24 dev ipvlan 
ip link set ipvlan up

# Create ipvlan network
docker network create -d ipvlan --subnet=192.168.200.0/24 --gateway=192.168.200.1  -o ipvlan_mode=l3 -o parent=$PARENT_IF ipvlan-net

# Run container with static IP
docker run -d --net=ipvlan-net --ip=192.168.200.10 nginx
