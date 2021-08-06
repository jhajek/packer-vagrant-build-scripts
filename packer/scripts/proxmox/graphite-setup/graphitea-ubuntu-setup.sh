#!/bin/bash 
set -e
set -v

##################################################
sudo apt-get update
sudo apt-get install -y python3-dev python3-pip python3-setuptools
#http://askubuntu.com/questions/549550/installing-graphite-carbon-via-apt-unattended
# sudo DEBIAN_FRONTEND=noninteractive apt-get -y --allow-change-held-packages install graphite-carbon python-whisper
sudo apt-get install -y graphite-carbon python-whisper
sudo apt-get install -y apt-transport-https 

# P.135 - Listing 4.13: Installing the graphite-api package on Ubuntu
sudo apt-get install -y graphite-api gunicorn3

# https://grafana.com/grafana/download
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_7.1.5_amd64.deb
sudo dpkg -i grafana_7.1.5_amd64.deb

# cloning source code examples for the book
git clone https://github.com/turnbullpress/aom-code.git

# Not needed
# sudo cp -v /home/vagrant/aom-code/4/graphite/graphite-api.service /lib/systemd/system/
# P.137
sudo cp -v /home/vagrant/aom-code/4/graphite/carbon.conf /etc/carbon/
# P.153
sudo cp -v /home/vagrant/aom-code/4/graphite/graphite-carbon.default /etc/default/graphite-carbon
# P.157
sudo systemctl stop carbon-relay@1.service
sudo rm -f /lib/systemd/system/carbon-relay@.service
sudo systemctl stop carbon-cache.service
sudo rm -f /lib/systemd/system/carbon-cache.service
sudo cp -v /home/vagrant/aom-code/4/graphite/carbon-cache@.service /lib/systemd/system/
sudo cp -v /home/vagrant/aom-code/4/graphite/carbon-relay@.service /lib/systemd/system/
# P.159
sudo cp -v /home/vagrant/aom-code/4/graphite/graphite-api.yaml /etc/
sudo touch /var/lib/graphite/api_search_index
sudo touch /etc/carbon/storage-aggregation.conf
##################################################################################################
# Start Services
##################################################################################################
sudo systemctl enable carbon-cache@1.service
sudo systemctl enable carbon-cache@2.service
sudo systemctl start carbon-cache@1.service
sudo systemctl start carbon-cache@2.service

sudo systemctl enable carbon-relay@1.service
sudo systemctl start carbon-relay@1.service

sudo systemctl daemon-reload 
sudo systemctl enable graphite-api
sudo systemctl start graphite-api

sudo systemctl enable grafana-server
sudo systemctl start grafana-server
