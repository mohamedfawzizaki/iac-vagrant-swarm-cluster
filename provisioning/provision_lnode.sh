#!/bin/bash

# Exit on any error
set -e

apt-get update

apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker vagrant

# Initialize the swarm
docker swarm init --advertise-addr $LEADER_NODE_IP

echo "${LEADER_NODE_IP}" > /vagrant/secrets/leader_node_ip
docker swarm join-token -q manager > /vagrant/secrets/manager_token
docker swarm join-token -q worker > /vagrant/secrets/worker_token