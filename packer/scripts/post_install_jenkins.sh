#!/bin/bash 
set -e
set -v

sudo timedatectl set-timezone America/Chicago


# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/init-users
sudo cat /etc/sudoers.d/init-users

# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh

wget http://mirrors.jenkins.io/war-stable/2.60.1/jenkins.war

sudo apt-get update -y
sudo apt-get install -y openjdk-8-jre

sudo ufw enable
sudo ufw allow 8080

sudo systemctl enable jenkins
sudo systemctl start jenkins