#!/bin/bash 
set -e
set -v

# https://marcofranssen.nl/packer-io-machine-building-and-provisioning-part-2/
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


# Adding latest stable Repo for Nginx install - ubuntu seems to tail behind
# https://www.linuxbabe.com/nginx/nginx-latest-version-ubuntu-16-04-16-10
sudo touch /etc/apt/sources.list.d/nginx.list
echo "deb http://nginx.org/packages/mainline/ubuntu/ xenial nginx\ndeb-src http://nginx.org/packages/mainline/ubuntu/ xenial nginx" | sudo tee /etc/apt/sources.list.d/nginx.list 
wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key

# Update the system and distribution
sudo apt-get update -y && sudo apt-get -y dist-upgrade

# https://dba.stackexchange.com/questions/59317/install-mariadb-10-on-ubuntu-without-prompt-and-no-root-password
# http://dba.stackexchange.com/questions/35866/install-mariadb-without-password-prompt-in-ubuntu?newreg=426e4e37d5a2474795c8b1c911f0fb9f
# From <http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423> 
export DEBIAN_FRONTEND=noninteractive
echo "mariadb-server mysql-server/root_password password $DBPASS" | sudo  debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password $DBPASS" | sudo debconf-set-selections

sudo apt-get install -y nginx php7.0 php-fpm mariadb-server graphviz aspell php7.0-pspell php7.0-curl php7.0-gd php7.0-intl php7.0-mysql php7.0-xml php7.0-xmlrpc php7.0-ldap php7.0-zip php7.0-soap php7.0-mbstring fail2ban

sudo systemctl enable mysql.service
sudo systemctl start mysql.service
sudo systemctl enable nginx.service
sudo systemctl start nginx.service

git clone git://git.moodle.org/moodle.git
cd moodle
git branch --track MOODLE_32_STABLE origin/MOODLE_32_STABLE
git checkout MOODLE_32_STABLE

# sudo rm /var/www/html/index.html
sudo mv ~/moodle/* /usr/share/nginx/html

#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails
sudo sed -i "s/bantime=600/bantime=-1/g" /etc/fail2ban/jail.conf
sudo systemctl enable fail2ban
sudo service fail2ban restart

# Enable Firewall
# https://serverfault.com/questions/809643/how-do-i-use-ufw-to-open-ports-on-ipv4-only
sudo ufw enable
ufw allow proto tcp to 0.0.0.0/0 port 22
ufw allow proto tcp to 0.0.0.0/0 port 80

# Inject the username and password for autologin later in a ~/.my.cnf file
# http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423#103423
# https://stackoverflow.com/questions/8020297/mysql-my-cnf-file-found-option-without-preceding-group
#echo -e "[mysqld] \n\n" > ~/.my.cnf
#echo -e "[client] \n user = root \n password = $DBPASS" >> ~/.my.cnf
#echo -e "\n port = 3306 \n socket = /var/run/mysqld/mysqld.sock" >> ~/.my.cnf

# Mariadb create user and tables commands
cd ~
git clone https://github.com/jhajek/commands
cd commands/sql
cp ./my.cnf ~/.my.cnf
mysql -u root < commands.sql
