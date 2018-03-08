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
#sudo mkdir -p /home/vagrant/.ssh
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys
echo "All Done!"

#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails
sudo sed -i "s/bantime = 600/bantime = -1/g" /etc/fail2ban/jail.conf
sudo systemctl enable fail2ban
sudo service fail2ban restart

# set the /etc/hosts file to match hostname
echo "$WEBSERVERIP     ws  ws.sat.iit.edu" | sudo tee -a /etc/hosts

# enable and allow ports in firewall
# https://serverfault.com/questions/790143/ufw-enable-requires-y-prompt-how-to-automate-with-bash-script
ufw --force enable
ufw allow proto tcp to 0.0.0.0/0 port 22
ufw allow proto tcp to 0.0.0.0/0 port 80
ufw allow proto tcp to 0.0.0.0/0 port 443

#Install apache2 webserver
sudo apt-get update
sudo apt-get install -y apache2 mysql-client php7.0 libapache2-mod-php7.0 php7.0-mysql

# chown the cloned github repo files so the user owns it 
sudo chown -R vagrant:vagrant ~/hajek
# copying the php code to the /var/www/html directory to serve php files
sudo cp ./hajek/itmt-430/db-samples/*.php /var/www/html

# include statement to place values into an include file for the connection string in test-select.php
# https://unix.stackexchange.com/questions/4335/how-to-insert-text-into-a-root-owned-file-using-sudo
echo "<?php" | sudo tee -a /var/www/html/connection-info.php
echo "\$endpoint=\"$DATABASEIP\";  // this is the public IP of the database server" | sudo tee -a /var/www/html/connection-info.php
echo "\$user=\"$DATABASEUSERNAME\"; //this is the same username that you created in the create-user-with-grants.sql file, change this from root as root is not allowed to make remote connections at all in mysql anymore" | sudo tee -a /var/www/html/connection-info.php
echo "\$password=\"$USERPASS\";  //this is the password that you entered in the create-user-with-grants.sql file after the IDENTIFIED BY string" | sudo tee -a /var/www/html/connection-info.php
echo "\$dbname=\"$DATABASENAME\"; //this is the name of the database you created in create.sql -- store if you keep the default setting" | sudo tee -a /var/www/html/connection-info.php 
echo "?>" | sudo tee -a /var/www/html/connection-info.php

# Create Ubuntu 16.04 Self-Signed Cert for Apache2
# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-16-04

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=US/ST=Illinois/L=Chicago/O=IIT-Company/OU=Org/CN=www.school.com"
# While we are using OpenSSL, we should also create a strong Diffie-Hellman group, which is used in negotiating Perfect Forward Secrecy with clients.
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048



# Enable the service and start the service
sudo systemctl enable apache2
sudo systemctl restart apache2
