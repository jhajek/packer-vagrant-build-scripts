#!/bin/bash 
set -e
set -v

sudo timedatectl set-timezone America/Chicago

# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is vagrant
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant


# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys
echo "All Done!"

sudo apt-get update -y
sudo apt-get install -y openjdk-8-jdk-headless

# Install Jenkins deb package
wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.89.2_all.deb 
sudo dpkg -i jenkins_2.89.2_all.deb

sudo systemctl enable jenkins
sudo systemctl start jenkins

sudo ufw enable
sudo ufw allow 8080

