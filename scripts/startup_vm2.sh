#!/bin/bash
apt update && apt install -y docker.io
systemctl start docker

# Create ipvlan network
docker network create -d ipvlan   --subnet=192.168.200.0/24   --gateway=192.168.200.1   -o parent=eth0 ipvlan-net

# Run container with static IP
docker run -d --net=ipvlan-net --ip=192.168.200.10 nginx
