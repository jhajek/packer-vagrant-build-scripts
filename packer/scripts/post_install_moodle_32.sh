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
# http://dba.stackexchange.com/questions/35866/install-mariadb-without-password-prompt-in-ubuntu?newreg=426e4e37d5a2474795c8b1c911f0fb9f
# From <http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423> 
export DEBIAN_FRONTEND=noninteractive
echo "mariadb-server mysql-server/root_password password PASS" | sudo  debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password PASS" | sudo debconf-set-selections

sudo apt-get install -y nginx php7.0 php-fpm mariadb-server graphviz aspell php7.0-pspell php7.0-curl php7.0-gd php7.0-intl php7.0-mysql php7.0-xml php7.0-xmlrpc php7.0-ldap php7.0-zip php7.0-soap php7.0-mbstring fail2ban

sudo systemctl enable mysql.service
sudo systemctl start mysql.service
sudo systemctl enable nginx.service
sudo systemctl start nginx.service

sudo git clone git://git.moodle.org/moodle.git
cd moodle
sudo git branch -a
sudo git branch --track MOODLE_32_STABLE origin/MOODLE_32_STABLE
sudo git checkout MOODLE_32_STABLE

# Move the cloned files to /var/www/html which is where Nginx on Ubuntu serves web pages.

# Create empty database
#https://docs.moodle.org/33/en/Installation_quick_guide#Create_a_database

sudo rm /var/www/html/index.html
sudo mv ./moodle/* /var/www/html

#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails
sudo sed -i "s/bantime=600/bantime=-1/g" /etc/fail2ban/jail.conf
sudo systemctl enable fail2ban
sudo service fail2ban restart

# Enable Firewall
# https://serverfault.com/questions/809643/how-do-i-use-ufw-to-open-ports-on-ipv4-only
sudo ufw enable
ufw allow proto tcp to 0.0.0.0/0 port 22
ufw allow proto tcp to 0.0.0.0/0 port 80

# How to create a user that only has mysqldump privilleges
# https://stackoverflow.com/questions/8658996/minimum-grants-needed-by-mysqldump-for-dumping-a-full-schema-triggers-are-miss

# Mariadb create user and tables commands

# Inject the username and password for autologin later in a ~/.my.cnf file
# http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423#103423

echo -e "[client] \n user = root \n password = PASS" > ~/.my.cnf
echo -e "\n port = 3306 \n socket          = /var/run/mysqld/mysqld.sock" >> ~/.my.cnf

