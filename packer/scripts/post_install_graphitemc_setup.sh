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

#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails
sudo sed -i "s/bantime=600/bantime=-1/g" /etc/fail2ban/jail.conf
sudo systemctl enable fail2ban
sudo service fail2ban restart

##################################################
# Add User customizations below here
##################################################
sudo apt-get update
#http://askubuntu.com/questions/549550/installing-graphite-carbon-via-apt-unattended
sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y --force-yes install graphite-carbon
sudo apt-get install -y apt-transport-https 

# P.134 - Listing 4.10: Adding the Graphite-API Package Cloudkey
curl https://packagecloud.io/gpg.key | sudo apt-key add -

# P.134 - Listing 4.11: Adding the Package Cloud exoscale repository listing
sudo sh -c "echo deb https://packagecloud.io/exoscale/community/ubuntu/ trusty main > /etc/apt/sources.list.d/exoscale_community.list"
sudo apt-get update -y 

# P.135 - Listing 4.13: Installing the graphite-api package on Ubuntu
sudo apt-get install -y graphite-api

# P.136 - Listing 4.16: Adding the Grafana repository listing
sudo sh -c "echo deb https://packagecloud.io/grafana/stable/debian/ wheezy main > /etc/apt/sources.list.d/packagecloud_grafana.list"

# P.137 - Listing 4.17: Adding the Package Cloudkey
curl https://packagecloud.io/gpg.key | sudo apt-key add -

# P.137 - Listing 4.18: Installing the Grafana package
sudo apt-get update -y
sudo apt-get install -y grafana

git clone https://github.com/jhajek/commands
sudo cp ~/commands/cnf/graphite/carbon.conf /etc/carbon/carbon.conf
sudo cp ~/commands/cnf/graphite/storage-schemas.conf /etc/carbon/storage-schemas.conf
sudo touch /etc/carbon/storage-aggregation.conf
sudo cp ~/commands/cnf/graphite/carbon-cache-ubuntu.init /etc/init.d/carbon-cache
sudo chmod 0755 /etc/init.d/carbon-cache
sudo update-rc.d carbon-cache defaults
sudo cp carbon-relay-ubuntu.init /etc/init.d/carbon-relay
sudo chmod 0755 /etc/init.d/carbon-relay
sudo update-rc.d carbon-relay defaults
