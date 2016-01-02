#!/bin/bash 
set -e
set -v

sudo add-apt-repository -y ppa:adiscon/v8-stable
sudo add-apt-repository -y ppa:formorer/icinga
sudo apt-get update -y
sudo apt-get install -y rsyslog


# Install Ganglia as a client to the central server
sudo apt-get install -y ganglia-monitor 
