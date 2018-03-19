#!/bin/sh -x

#update 
apt-get -yqq update

#Install Apache
apt-get -yqq install apache2

# set the /etc/hosts file to match hostname
echo "$WEBSERVERIP     ws  ws.sat.iit.edu" | sudo tee -a /etc/hosts

#Install apache2 webserver
sudo apt-get update
sudo apt-get install -y apache2 mysql-client php7.0 libapache2-mod-php7.0 php7.0-mysql git

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
