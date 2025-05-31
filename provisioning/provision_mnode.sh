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

LEADER_NODE_IP_IP=$(cat /vagrant/secrets/leader_node_ip)
JOIN_TOKEN=$(cat /vagrant/secrets/manager_token)
docker swarm join --token $JOIN_TOKEN $LEADER_NODE_IP_IP:2377