#!/bin/bash 
set -e
set -v

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
