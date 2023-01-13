#!/bin/bash 
set -e
set -v

# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is ubuntu
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant

# Installing Vagrant keys
# wget --no-check-certificate 'https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub'
# sudo mkdir -p /home/vagrant/.ssh
# sudo chown -R vagrant:vagrant /home/vagrant/.ssh
# cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
# sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys
# echo "All Done!"

##################################################
# Add User customizations below here
##################################################
# https://docs.k3s.io/installation/configuration#configuration-with-install-script
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--flannel-backend none --token 12345" sh -s -
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --flannel-backend none" K3S_TOKEN=12345 sh -s -
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -s - --flannel-backend none
curl -sfL https://get.k3s.io | K3S_TOKEN=12345 sh -s - server --flannel-backend none
curl -sfL https://get.k3s.io | sh -s - --flannel-backend none --token 12345

sudo apt update
sudo apt install -y firewalld

sudo systemctl enable firewalld
sudo systemctl start firewalld

sudo firewall-cmd --zone=public --add-port=6443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8742/tcp --permanent
sudo firewall-cmd --reload
