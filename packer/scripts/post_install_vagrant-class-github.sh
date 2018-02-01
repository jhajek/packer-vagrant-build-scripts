#!/bin/bash 
set -e
set -v


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

#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails
sudo sed -i "s/bantime = 600/bantime = -1/g" /etc/fail2ban/jail.conf
sudo systemctl enable fail2ban
sudo service fail2ban restart

##################################################
# Add User customizations below here
##################################################
# Here we are adding the basic contents of a file named: config and place that in .ssh directory so as to relate the private key to the github deploy key

# You need to move private key to the correct directory location - place the location in the root user's home directory because these commands are executed not as the user but as root...
sudo mv /home/vagrant/id_rsa_github_deploy_key /home/vagrant/.ssh/
# You need to move the ssh config file to the correct directory location
sudo mv /home/vagrant/config /home/vagrant/.ssh/

# You need to change the permission of the private key 
chmod 600 /home/vagrant/.ssh/id_rsa_github_deploy_key

# clone a private repo with the key
# https://stackoverflow.com/questions/4565700/specify-private-ssh-key-to-use-when-executing-shell-command-with-or-without-ruby
git clone git@github.com:illinoistech-itm/hajek.git


