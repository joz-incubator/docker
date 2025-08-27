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

# Create ipvlan network
docker network create -d ipvlan --subnet=192.168.200.0/24 -o parent=$PARENT_IF -o ipvlan_mode=l3 ipvlan-net

# Run container with static IP
docker run -d --net=ipvlan-net --ip=192.168.200.10 nginx
