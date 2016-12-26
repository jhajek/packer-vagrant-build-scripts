#!/bin/bash 
set -e
set -v

sudo timedatectl set-timezone America/Chicago

sudo echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vagrant
sudo echo 'Defaults:vagrant !requiretty' >> /etc/sudoers.d/vagrant

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
echo "deb https://pkg.jenkins.io/debian-stable binary/" | sudo tee -a /etc/apt/sources.list

sudo apt-get update -y
sudo apt-get install -y jenkins
