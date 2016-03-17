#!/bin/bash 
set -e
set -v

sudo add-apt-repository -y ppa:adiscon/v8-stable
sudo apt-get update -y
sudo apt-get install -y rsyslog

#echo ganglia-webfrontend ganglia-webfrontend/webserver boolean true | sudo debconf-set-selections
#echo ganglia-webfrontend ganglia-webfrontend/restart boolean true | sudo debconf-set-selections
#echo ganglia-webfrontend ganglia-webfrontend/restart seen true | sudo debconf-set-selections

# Install Ganglia as a client to the central server
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ganglia-monitor rrdtool gmetad ganglia-webfrontend

sudo cp /etc/ganglia-webfrontend/apache.conf /etc/apache2/sites-enabled/ganglia.conf


