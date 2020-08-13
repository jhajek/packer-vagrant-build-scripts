#!/bin/bash 
set -e
set -v

# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/init-users
sudo cat /etc/sudoers.d/init-users


# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
##################################################
# Change hostname and /etc/hosts
##################################################
cat << EOT >> /etc/hosts
# Nodes
192.168.33.10 riemanna riemanna.example.com
192.168.33.11 riemannb riemannb.example.com
192.168.33.12 riemannmc riemannmc.example.com
192.168.33.100 graphitea graphitea.example.com
192.168.33.101 graphiteb graphiteb.example.com
192.168.33.102 graphitemc graphitemc.example.com
192.168.33.201 ela1 ela1.example.com
192.168.33.202 ela2 ela2.example.com
192.168.33.203 ela3 ela3.example.com
192.168.33.204 logstash logstash.example.com
192.168.33.205 host1 host1.example.com
192.168.33.206 host2 host2.example.com
EOT

sudo hostnamectl set-hostname host1

##################################################
sudo apt-get update -y



