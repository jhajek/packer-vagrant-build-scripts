#!/bin/bash 
set -e
set -v

# cloning source code examples for the book
git clone https://github.com/turnbullpress/aom-code.git

sudo cp -v /home/vagrant/aom-code/4/riemann/riemann.config /etc/riemann
sudo cp -rv /home/vagrant/aom-code/4/riemann/examplecom /etc/riemann

# Doing a find and replace for the stock riemannmc for the my FQDN
sudo sed -i 's/riemannmc/jrh-riemannmc/' /etc/riemann/riemann.config
# Change the default name to match my FQDN
sudo sed -i 's/graphitea/jrh-graphitea/' /etc/riemann/examplecom/etc/graphite.clj

sudo systemctl daemon-reload
sudo systemctl restart riemann

# Install leiningen on Ubuntu - needed for riemann syntax checker
sudo apt-get install -y leiningen

# Riemann syntax checker download and install
git clone https://github.com/samn/riemann-syntax-check
cd riemann-syntax-check
lein uberjar
cd ../

