#!/bin/bash

# Update OS and install Docker
apt update && apt full-upgrade -y
apt install -y docker.io

# Ensure Docker is up to date
apt install --only-upgrade -y docker.io

# Start Docker
systemctl start docker

# Create ipvlan network
docker network create -d ipvlan   --subnet=192.168.200.0/24   --gateway=192.168.200.1   -o parent=eth0 ipvlan-net

# Run container with static IP
docker run -d --net=ipvlan-net --ip=192.168.200.10 nginx
