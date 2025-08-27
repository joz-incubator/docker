#!/bin/bash

# Update OS and install Docker
apt update && apt full-upgrade -y
apt install -y docker.io

# Ensure Docker is up to date
apt install --only-upgrade -y docker.io

# Start Docker
systemctl start docker

# Create ipvlan network
docker network create -d ipvlan \
  --subnet=192.168.100.0/24 \  # or 192.168.200.0/24 for vm2
  --gateway=192.168.100.1 \    # or 192.168.200.1 for vm2
  -o parent=eth0 ipvlan-net

# Run container with static IP
docker run -d --net=ipvlan-net --ip=192.168.100.10 nginx  # or 192.168.200.10 for vm2
