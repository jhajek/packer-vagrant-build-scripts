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

# Add customizations after this line
##################################################
# Change hostname and /etc/hosts
##################################################
cat << EOT >> /etc/hosts
# Nodes
192.168.33.10 riemanna riemanna.project.iit.edu
192.168.33.11 riemannb riemannb.project.iit.edu
192.168.33.12 riemannmc riemannmc.project.iit.edu
192.168.33.100 graphitea graphitea.project.iit.edu
192.168.33.101 graphiteb graphiteb.project.iit.edu
192.168.33.102 graphitemc graphitemc.project.iit.edu
EOT

sudo hostnamectl set-hostname graphitea

##################################################
sudo apt-get update
sudo apt-get install -y python3-dev python3-pip python3-setuptools
#http://askubuntu.com/questions/549550/installing-graphite-carbon-via-apt-unattended
sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y --force-yes install graphite-carbon python-whisper
sudo apt-get install -y apt-transport-https 

# P.135 - Listing 4.13: Installing the graphite-api package on Ubuntu
sudo apt-get install -y graphite-api gunicorn3

# https://grafana.com/grafana/download
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_7.1.3_amd64.deb
sudo dpkg -i grafana_7.1.3_amd64.deb

# cloning source code examples for the book
git clone https://github.com/turnbullpress/aom-code.git

##################################################################################################
# Start Services
##################################################################################################
sudo systemctl enable graphite-api
sudo systemctl enable grafana-server
sudo systemctl start graphite-api
sudo systemctl start grafana-server
