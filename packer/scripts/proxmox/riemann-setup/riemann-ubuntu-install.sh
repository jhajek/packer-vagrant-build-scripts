#!/bin/bash

##################################################
sudo apt-get update -y
sudo apt-get install -y ruby ruby-dev build-essential zlib1g-dev openjdk-8-jre collectd

# P.42 The Art of Monitoring
wget https://github.com/riemann/riemann/releases/download/0.3.6/riemann_0.3.6_all.deb
sudo dpkg -i riemann_0.3.6_all.deb

# cloning source code examples for the book
git clone https://github.com/turnbullpress/aom-code.git

# Install leiningen on Centos 7 - needed for riemann syntax checker
sudo apt-get install -y leiningen

# Riemann syntax checker download and install
git clone https://github.com/samn/riemann-syntax-check
cd riemann-syntax-check
lein uberjar
cd ../

sudo systemctl enable riemann
sudo systemctl start riemann
sudo systemctl enable collectd
sudo systemctl start collectd

# P. 44  Install ruby gem tools
sudo gem install riemann-tools
