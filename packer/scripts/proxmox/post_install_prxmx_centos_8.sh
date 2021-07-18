#!/bin/bash 
set -e
set -v

sudo yum install -y git rsync wget vim curl

sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --add-service=ssh --permanent
# Consul ports needed for Gossip protocol on the LAN
# https://www.consul.io/docs/install/ports
sudo firewall-cmd --add-port=8301/tcp --permanent
sudo firewall-cmd --add-port=8500/tcp --permanent
sudo firewall-cmd --reload

# https://github.com/hashicorp/terraform-provider-vsphere/issues/516
# Remove /etc/machine-id so that all the cloned machines will get their own IP address upon DHCP request
sudo rm -f /etc/machine-id
sudo touch /etc/machine-id