#!/bin/bash 
set -e
set -v

# Install dependencies to create a jenkins system
sudo apt-get update

# Install collectd for plugin management
sudo apt-get install -y collectd
