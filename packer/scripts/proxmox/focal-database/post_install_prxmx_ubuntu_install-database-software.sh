#!/bin/bash 
set -e
set -v

# Install Android and Jenkins Java Dependencies
sudo apt-get update
sudo apt-get install -y  mariadb-server postgresql

