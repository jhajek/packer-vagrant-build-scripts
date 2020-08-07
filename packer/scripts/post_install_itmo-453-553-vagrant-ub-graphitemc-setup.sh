#!/bin/bash 
set -e
set -v

# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/init-users
sudo cat /etc/sudoers.d/init-users

# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh

sudo apt-get update
sudo apt-get install python3-dev python3-pip python3-setuptools
#http://askubuntu.com/questions/549550/installing-graphite-carbon-via-apt-unattended
sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y --force-yes install graphite-carbon python-whisper
sudo apt-get install -y apt-transport-https 

# P.135 - Listing 4.13: Installing the graphite-api package on Ubuntu
sudo apt-get install -y graphite-api

# P.137 - Listing 4.18: Installing the Grafana package
sudo apt-get install -y grafana

##################################################################################################
# Start Services
##################################################################################################
