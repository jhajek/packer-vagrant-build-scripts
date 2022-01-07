#!/bin/bash 
set -e
set -v

##############################################################################################
# Add any additional firewall ports below this line in this format:
# sudo firewall-cmd --zone=public --add-port=####/tcp --permanent
# sudo firewall-cmd --zone=public --add-port=####/udp --permanent
##############################################################################################
sudo firewall-cmd --zone=public --add-port=8125/tcp --permanent
sudo firewall-cmd --zone=public --add-port=3000/tcp --permanent

sudo firewall-cmd --reload

