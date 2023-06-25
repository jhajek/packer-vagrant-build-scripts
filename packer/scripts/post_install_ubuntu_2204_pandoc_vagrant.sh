#!/bin/bash 
set -e
set -v

# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is ubuntu
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant

# Installing Vagrant keys
# wget --no-check-certificate 'https://raw.githubusercontent.com/hashicorp/vagrant/main/keys/vagrant.pub'
# sudo mkdir -p /home/vagrant/.ssh
# sudo chown -R vagrant:vagrant /home/vagrant/.ssh
# cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
# sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys
# echo "All Done!"

##################################################
# Add User customizations below here
##################################################
sudo apt-get install wget git
if [ -e ./pandoc-3.1.3-1-amd64.deb ]
  then
    sudo dpkg -i pandoc-3.1.3-1-amd64.deb
    rm ./pandoc-3.1.3-1-amd64.deb
  else
    wget https://github.com/jgm/pandoc/releases/download/3.1.3/pandoc-3.1.3-1-amd64.deb
    sudo dpkg -i pandoc-3.1.3-1-amd64.deb
    rm ./pandoc-3.1.3-1-amd64.deb
fi

git clone https://github.com/jhajek/Linux-text-book-part-1.git

wget http://packages.sil.org/sil.gpg
sudo apt-key add sil.gpg
sudo apt-add-repository -y "deb http://packages.sil.org/ubuntu/ $(lsb_release -sc) main"
sudo apt-get update
sudo apt-get -y install fonts-sil-charis

sudo apt-get -y install fonts-inconsolata