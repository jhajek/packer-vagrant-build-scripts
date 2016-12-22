#!/bin/bash 
set -e
set -v
# http://stackoverflow.com/questions/26595620/how-to-install-ruby-2-1-4-on-ubuntu-14-04
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update -y
sudo apt-get install -y ruby2.2 ruby2.2-dev build-essential zlib1g-dev openjdk-7-jre

# P.42 The Art of Monitoring
wget http://aphyr.com/riemann/riemann_0.2.11_all.deb
dpkg -i riemann_0.2.11_all.deb

sudo service riemann start

# P. 44  Install ruby gem tools
sudo gem install --no-ri --no-rdoc riemann-tools


# http://stackoverflow.com/questions/5171901/sed-command-find-and-replace-in-file-and-overwrite-file-doesnt-work-it-empties

#sudo sed -i 's/ubuntu/riemannmc/g' /etc/hostname 
#sudo service hostname restart
#exec bash

# Installing vagrant keys 
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'  
sudo mkdir -p /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys

#Setting the /etc/hosts entry
# http://serverfault.com/questions/46645/shell-command-for-getting-ip-address

IP=`hostname -I | cut -d' ' -f2`
hname=`cat /etc/hostname`
domain=".example.org"
# http://unix.stackexchange.com/questions/20573/sed-insert-something-to-the-last-line
sudo sed -i -e "\$a$IP      $hname$domain" /etc/hosts 
cat /etc/hosts
