#!/bin/bash 
set -e
set -v

# cloning source code examples for the book
git clone https://github.com/turnbullpress/aom-code.git

sudo mv -v /home/vagrant/aom-code/4/riemann/riemann.config_riemannmc /etc/riemann/riemann.config

sudo sed -i 's/graphitea/jrh-graphitemc.service.consul/' /home/vagrant/aom-code/4/riemann/examplecom/etc/graphite.clj
sudo sed -i 's/productiona/jrh-productionmc.service.consul/' /home/vagrant/aom-code/4/riemann/examplecom/etc/graphite.clj

# Install leiningen on Ubuntu - needed for riemann syntax checker
sudo apt-get install -y leiningen

# Riemann syntax checker download and install
git clone https://github.com/samn/riemann-syntax-check
cd riemann-syntax-check
lein uberjar
cd ../
