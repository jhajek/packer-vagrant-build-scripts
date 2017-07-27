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

sudo apt-get update -y && sudo apt-get -y dist-upgrade

# https://dba.stackexchange.com/questions/59317/install-mariadb-10-on-ubuntu-without-prompt-and-no-root-password
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password password PASS'
sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password PASS'

sudo apt-get install -y mariadb-server fail2ban

sudo systemctl enable mysql.service
sudo systemctl start mysql.service

# Create empty database
#https://docs.moodle.org/33/en/Installation_quick_guide#Create_a_database

#inject the username and password for autologin later in a ~/.my.cnf file
# http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423#103423

echo -e "[client] \n user = root \n password = $MARIADBPASSWORD" > ~/.my.cnf
echo -e "\n port = 3306 \n socket          = /var/run/mysqld/mysqld.sock" >> ~/.my.cnf


#auto run or source a script
# http://dev.mysql.com/doc/refman/5.0/en/batch-mode.html
mysql -u root < commands.sql

#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails
sudo sed -i "s/bantime=600/bantime=-1/g" /etc/fail2ban/jail.conf
sudo service fail2ban restart