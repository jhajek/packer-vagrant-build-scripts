#!/bin/bash

##################################################
# Install Elrepo - The Community Enterprise Linux Repository (ELRepo) - http://elrepo.org/tiki/tiki-index.php
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# https://wiki.centos.org/AdditionalResources/Repositories
sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
# Install epel repo for collectd
sudo yum install -y epel-release

sudo yum install -y java-1.8.0-openjdk daemonize curl collectd wget
# Due to needing a tty to run sudo, this install command adds all the pre-reqs to build the virtualbox additions
sudo yum install -y kernel-devel gcc binutils make perl bzip2 python3 python3-pip python3-setuptools

###############################################################################################################
# firewalld additions to make CentOS and riemann to work
###############################################################################################################
# Adding firewall rules for riemann - Centos 7 uses firewalld (Thanks Lennart...)
# http://serverfault.com/questions/616435/centos-7-firewall-configuration
sudo firewall-cmd --zone=public --add-port=5555/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5556/udp --permanent
# Websockets are TCP... for now - http://stackoverflow.com/questions/4657033/javascript-websockets-with-udp
sudo firewall-cmd --zone=public --add-port=5557/tcp --permanent
###############################################################################################################

###############################################################################################################
# Fetch and install the Riemann RPM
###############################################################################################################
wget https://github.com/riemann/riemann/releases/download/0.3.6/riemann-0.3.6-1.noarch-EL8.rpm
sudo rpm -Uvh riemann-0.3.6-1.noarch-EL8.rpm

# cloning source code examples for the book
git clone https://github.com/turnbullpress/aom-code.git

# Install leiningen on Centos 7 - needed for riemann syntax checker
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod +x lein
sudo cp ./lein /usr/local/bin

# Riemann syntax checker download and install
git clone https://github.com/samn/riemann-syntax-check
cd riemann-syntax-check
lein uberjar

# Enable to Riemann service to start on boot and start the service
sudo systemctl enable collectd
sudo systemctl start collectd
sudo systemctl enable riemann
sudo systemctl start riemann

# P. 44  Install ruby gem tool, Centos 7 has Ruby 2.x as the default
sudo yum install -y ruby ruby-devel gcc libxml2-devel
sudo gem install riemann-tools
echo "All Done!"