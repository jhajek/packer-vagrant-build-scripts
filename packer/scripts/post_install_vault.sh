#!/bin/bash 
set -e

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vault

echo "export VAULT_ADDR='https://127.0.0.1:8200'" >> /home/vagrant/.bashrc
echo 'export VAULT_SKIP_VERIFY="true"' >> /home/vagrant/.bashrc

sudo systemctl start vault
sudo systemctl enable vault
