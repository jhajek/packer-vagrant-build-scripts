#!/bin/bash
##############################################################################################
# This is where you would update or open new firewall ports.
# By default is open:
# Port 22 for SSH
# port 8301 and 8500 are the Gossip protocol and for the instance to be able to 
# register with the Consul DNS service 
# Instances will be using firewalld
##############################################################################################

sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --add-service=ssh --permanent
# Consul ports needed for Gossip protocol on the LAN
# https://www.consul.io/docs/install/ports
sudo firewall-cmd --add-port=8301/tcp --permanent
sudo firewall-cmd --add-port=8500/tcp --permanent
##############################################################################################
# Add any additional firewall ports below this line in this format:
# sudo firewall-cmd --add-port=####/tcp --permanent
# sudo firewall-cmd --add-port=####/udp --permanent
##############################################################################################
sudo firewall-cmd --reload

