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


sudo apt-get update -y
sudo apt-get install -y ruby ruby-dev build-essential zlib1g-dev openjdk-8-jre

# P.42 The Art of Monitoring
wget https://github.com/riemann/riemann/releases/download/0.2.14/riemann_0.2.14_all.deb
sudo dpkg -i riemann_0.2.14_all.deb

sudo service riemann start

# P. 44  Install ruby gem tools
sudo gem install --no-ri --no-rdoc riemann-tools

# epub 34%
# Installing collectd basic plugins for metric collection
sudo sudo add-apt-repository -y ppa:collectd/collectd-5.5
sudo apt-get update
sudo apt-get -y install collectd
sudo mkdir /etc/collectd.d

sudo systemctl enable collectd
sudo service collectd start





