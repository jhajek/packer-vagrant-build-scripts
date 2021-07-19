#!/bin/bash

# script to install hashicorp consul for Proxmox servers

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y consul

sudo mv -v /home/vagrant/system.hcl /etc/consul.d/
sudo systemctl enable consul.service
sudo systemctl daemon-reload
sudo systemctl restart consul
sudo systemctl status consul
# with the clone there is a duplicate consul node-id - going to try to delete the node-id so that a new one is generated when Terraform deploys these instances
sudo cat /opt/consul/node-id
sudo rm /opt/consul/node-id
