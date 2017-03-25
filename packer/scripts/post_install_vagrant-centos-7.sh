#!/bin/bash 
set -e
set -v


# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is vagrant
# http://chrisbalmer.io/vagrant/2015/07/02/build-rhel-centos-7-vagrant-box.html
# Read this bug track to see why this line below was the source of a lot of trouble.... 
# https://github.com/mitchellh/vagrant/issues/1482
#echo "Defaults requiretty" | sudo tee -a /etc/sudoers.d/init-users
# Need to add this first as wget not part of the base package...
sudo yum install -y wget
#################################################################################################################
# code needed to allow for vagrant to function seamlessly
#################################################################################################################
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant

# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys

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

# Install Elrepo - The Community Enterprise Linux Repository (ELRepo) - http://elrepo.org/tiki/tiki-index.php
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sudo yum install -y epel-release # https://wiki.centos.org/AdditionalResources/Repositories
sudo yum makecache fast


# Install base dependencies -  Centos 7 mininal needs the EPEL repo in the line above and the package daemonize
sudo yum update -y
sudo yum install -y wget unzip vim git java-1.7.0-openjdk daemonize python-setuptools curl
# Due to needing a tty to run sudo, this install command adds all the pre-reqs to build the virtualbox additions
sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2


echo "All Done!"
