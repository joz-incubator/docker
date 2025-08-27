#!/bin/bash

# Update OS and install Docker
apt update && apt full-upgrade -y
apt install -y docker.io

# Ensure Docker is up to date
apt install --only-upgrade -y docker.io

# Start Docker
systemctl start docker

