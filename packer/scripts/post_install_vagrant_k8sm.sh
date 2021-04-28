#!/bin/bash 
set -e
set -v

# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is vagrant
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant

# Installing Vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/ubuntu/.ssh
sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh
cat ./vagrant.pub >> /home/ubuntu/.ssh/authorized_keys
sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys
echo "All Done!"

##################################################
# Add User customizations below here
##################################################

cat << EOT >> /etc/hosts
# Nodes
192.168.33.10 k8sm k8sm.iltech.iit.edu
192.168.33.11 k8sw1 k8sw1.iltech.iit.edu
192.168.33.12 k8sw2 k8sw2.iltech.iit.edu
EOT

sudo apt install -y apt-transport-https curl
sudo add-apt-repository -y ppa:k8s-maintainers/1.19
sudo apt update
sudo apt install -y kubeadm kubelet cri-tools kubernetes-cni docker.io vim

