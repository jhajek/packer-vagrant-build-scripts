#!/bin/bash 
set -e
set -v
set -x

sudo add-apt-repository -y ppa:adiscon/v8-stable
#sudo add-apt-repository -y ppa:formorer/icinga
sudo apt-get update -y
wget -P /tmp https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_linux_amd64.zip
unzip /tmp/consul_0.6.0_linux_amd64.zip -d /usr/local/bin


# Install Ganglia as a client to the central server
#sudo apt-get install -y ganglia-monitor 
sudo apt-get install -y rsyslog dkms linux-headers-$(uname -r)
#sudo mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
#sudo sh /mnt/VBoxLinuxAdditions.run
#sudo umount /mnt

sudo echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vagrant
sudo echo 'Defaults:vagrant !requiretty' >> /etc/sudoers.d/vagrant
#sudo apt-get install -y icinga2


#sudo apt-get install -y  mysql-server mysql-client
#sudo apt-get install -y  icinga2-ido-mysql
#sudo icinga2 feature enable ido-mysql
#sudo service icinga2 restart

#consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul &
