#!/bin/bash 
set -e
set -v
set -x

sudo apt-get update -y
wget -P /tmp https://releases.hashicorp.com/consul/0.7.2/consul_0.7.2_linux_amd64.zip
unzip /tmp/consul_0.7.2_linux_amd64.zip -d /usr/local/bin



sudo echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vagrant
sudo echo 'Defaults:vagrant !requiretty' >> /etc/sudoers.d/vagrant


