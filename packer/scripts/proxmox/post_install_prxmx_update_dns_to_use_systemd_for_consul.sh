#!/bin/bash

# Script to modify the systemd-resolved to use the local Consul DNS store for resolving the .consul DNS namespace
# https://learn.hashicorp.com/tutorials/consul/dns-forwarding?in=consul/security-networking#systemd-resolved-setup

# Need to update: /etc/systemd/resolved.conf

sudo sed -i 's/#Domains=/Domains=~consul/g' /etc/systemd/resolved.conf
sudo sed -i 's/#DNS=/DNS=127.0.0.1/g' /etc/systemd/resolved.conf

sudo systemctl daemon-reload
sudo systemctl restart systemd-resolved

# The main limitation with this configuration is that the DNS field cannot contain ports. So for this to work either Consul must be configured to listen on port 53 instead of 8600 or you can use iptables to map port 53 to 8600. The following iptables commands are sufficient to do the port mapping.

sudo iptables -t nat -A OUTPUT -d localhost -p udp -m udp --dport 53 -j REDIRECT --to-ports 8600
sudo iptables -t nat -A OUTPUT -d localhost -p tcp -m tcp --dport 53 -j REDIRECT --to-ports 8600

# Structure to keep the iptables adjusted DNS entries
sudo mkdir -p /etc/iptables
sudo /sbin/iptables-save | sudo tee /etc/iptables/rules.v4
