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


# http://stackoverflow.com/questions/26595620/how-to-install-ruby-2-1-4-on-ubuntu-14-04
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update -y
sudo apt-get install -y ruby2.2 ruby2.2-dev build-essential zlib1g-dev openjdk-7-jre

# P.42 The Art of Monitoring
wget https://github.com/riemann/riemann/releases/download/0.2.14/riemann_0.2.14_all.deb
dpkg -i riemann_0.2.14_all.deb

sudo service riemann start

# P. 44  Install ruby gem tools
sudo gem install --no-ri --no-rdoc riemann-tools





