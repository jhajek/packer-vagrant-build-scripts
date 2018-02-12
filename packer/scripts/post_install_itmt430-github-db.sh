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

##################################################
# Add User customizations below here
##################################################

export DEBIAN_FRONTEND=noninteractive
echo "mariadb-server mysql-server/root_password password $DBPASS" | sudo  debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password $DBPASS" | sudo debconf-set-selections

sudo apt-get update
sudo apt-get install -y mariadb-server 

# chown the cloned github repo files so the user owns it 
sudo chown -R vagrant:vagrant ~/hajek
# copying the php code to the /var/www/html directory to serve php files

# Inject the username and password for autologin later in a ~/.my.cnf file
# http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423#103423
# https://stackoverflow.com/questions/8020297/mysql-my-cnf-file-found-option-without-preceding-group

echo -e "[mysqld]" > /root/.my.cnf
echo -e "\n\n[client]\nuser = root\npassword = $DBPASS" >> /root/.my.cnf
echo -e "\nport = 3306\nsocket = /var/run/mysqld/mysqld.sock\n" >> /root/.my.cnf

echo -e "[mysqld]\n\n" > /home/vagrant/.my.cnf
echo -e "[client]\nuser = worker\npassword = $USERPASS" >> /home/vagrant/.my.cnf
echo -e "\nport = 3306\nsocket = /var/run/mysqld/mysqld.sock\n" >> /home/vagrant/.my.cnf
echo -e "\ndefault-character-set = utf8mb4\n" >> /home/vagrant/.my.cnf

# Enable the service and start the service
sudo systemctl enable mysql
sudo systemctl restart mysql

# Enable Firewall
# https://serverfault.com/questions/809643/how-do-i-use-ufw-to-open-ports-on-ipv4-only
sudo ufw enable
ufw allow proto tcp to 0.0.0.0/0 port 22
ufw allow proto tcp to 0.0.0.0/0 port 80
ufw allow proto tcp to 0.0.0.0/0 port 443

# https://stackoverflow.com/questions/8055694/how-to-execute-a-mysql-command-from-a-shell-script
# This section uses the user environment variables declared in packer json build template
# #USERPASS and $BKPASS
mysql -u root -e "CREATE DATABASE mydb DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

mysql -u root -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON mydb.* TO worker@localhost IDENTIFIED BY '$USERPASS'; flush privileges;"

# Create a user that has privilleges just to do a mysqldump backup
# http://www.fromdual.com/privileges-of-mysql-backup-user-for-mysqldump
#sudo mysql -u root -e "CREATE USER 'backup'@'localhost' IDENTIFIED BY '$BKPASS'; GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER, LOCK TABLES ON *.* TO 'backup'@'localhost';"