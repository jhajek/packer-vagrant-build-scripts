#!/bin/bash

# Script to modify the systemd-resolved to use the local Consul DNS store for resolving the .consul DNS namespace
# https://learn.hashicorp.com/tutorials/consul/dns-forwarding?in=consul/security-networking#systemd-resolved-setup

# Need to update: /etc/systemd/resolved.conf

sudo sed -i 's/#Domains=/Domains=~consul/g' /etc/systemd/resolved.conf
sudo sed -i 's/#DNS=/DNS=127.0.0.1/g' /etc/systemd/resolved.conf

sudo systemctl daemon-reload
sudo systemctl restart systemd-resolved
# see iptables-dns-adjustment.sh on how the iptables/nftables will be automatically adjusted to forward local dns requets to port 8600 on each boot or reboot

