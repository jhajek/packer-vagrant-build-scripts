#!/bin/bash 
set -e
set -v

sudo timedatectl set-timezone America/Chicago

sudo add-apt-repository -y ppa:adiscon/v8-stable

wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

echo "deb http://pkg.jenkins-ci.org/debian binary/" | sudo tee -a /etc/apt/sources.list

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y apache2
sudo apt-get install -y openjdk-7-jdk
sudo apt-get install -y jenkins
sudo apt-get install -y rsyslog

# Install Ganglia as a client to the central server
#sudo apt-get install -y ganglia-monitor 

