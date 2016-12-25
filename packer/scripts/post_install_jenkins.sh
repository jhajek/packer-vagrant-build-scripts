#!/bin/bash 
set -e
set -v

sudo timedatectl set-timezone America/Chicago


wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

echo "deb http://pkg.jenkins-ci.org/debian binary/" | sudo tee -a /etc/apt/sources.list

sudo echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vagrant
sudo echo 'Defaults:vagrant !requiretty' >> /etc/sudoers.d/vagrant


sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y jenkins
sudo apt-get install -y dkms linux-headers-$(uname -r)

