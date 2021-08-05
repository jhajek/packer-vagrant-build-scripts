#!/bin/bash 
set -e
set -v

##################################################
# Due to needing a tty to run sudo, this install command adds all the pre-reqs to build the virtualbox additions
sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2 vim wget git rsync
###############################################################################################################
# firewalld additions to make CentOS and riemann to work
###############################################################################################################
# Adding firewall rules for riemann - Centos 7 uses firewalld (Thanks Lennart...)
# http://serverfault.com/questions/616435/centos-7-firewall-configuration
# Websockets are TCP... for now - http://stackoverflow.com/questions/4657033/javascript-websockets-with-udp
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --permanent --zone=public --add-port=5555/tcp --permanent
sudo firewall-cmd --permanent --zone=public --add-port=5556/udp --permanent
sudo firewall-cmd --permanent --zone=public --add-port=5557/tcp --permanent
sudo firewall-cmd --permanent --zone=public --add-port=8888/tcp --permanent
sudo firewall-cmd --permanent --zone=public --add-port=3000/tcp --permanent
sudo firewall-cmd --reload
###############################################################################################################
# cloning source code examples for the book
git clone https://github.com/turnbullpress/aom-code.git

sudo cp -v /home/vagrant/aom-code/4/riemann/riemann.config /etc/riemann
sudo cp -rv /home/vagrant/aom-code/4/riemann/examplecom /etc/riemann
# Doing a find and replace for the stock riemannmc for the my FQDN
sudo sed -i 's/riemannmc/jrh-riemannmc' /etc/riemann/riemann.config
# Change the default name to match my FQDN
sudo sed -i 's/graphitea/jrh-graphiteb' /etc/riemann/examplecom/etc/graphite.clj

sudo systemctl daemon-reload
sudo systemctl restart riemann

# Install leiningen on Centos 8 - needed for riemann syntax checker
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x lein
sudo cp ./lein /usr/local/bin

# Riemann syntax checker download and install
git clone https://github.com/samn/riemann-syntax-check
cd riemann-syntax-check
lein uberjar

echo "All Done!"
