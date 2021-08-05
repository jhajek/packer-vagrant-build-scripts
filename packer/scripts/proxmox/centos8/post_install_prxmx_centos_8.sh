#!/bin/bash 
set -e
set -v

# Installing default tools 
sudo yum install -y git rsync wget vim curl

# https://github.com/hashicorp/terraform-provider-vsphere/issues/516
# Remove /etc/machine-id so that all the cloned machines will get their own IP address upon DHCP request
sudo rm -f /etc/machine-id
sudo touch /etc/machine-id