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

# Update the system and distribution
sudo apt-get update -y && sudo apt-get -y dist-upgrade

# https://dba.stackexchange.com/questions/59317/install-mariadb-10-on-ubuntu-without-prompt-and-no-root-password
# http://dba.stackexchange.com/questions/35866/install-mariadb-without-password-prompt-in-ubuntu?newreg=426e4e37d5a2474795c8b1c911f0fb9f
# From <http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423> 
export DEBIAN_FRONTEND=noninteractive
echo "mariadb-server mysql-server/root_password password $DBPASS" | sudo  debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password $DBPASS" | sudo debconf-set-selections

sudo apt-get install -y nginx php7.0 php7.0-fpm php7.0-mysql mariadb-server graphviz aspell php7.0-pspell php7.0-curl php7.0-gd php7.0-intl php7.0-mysql php7.0-xml php7.0-xmlrpc php7.0-ldap php7.0-zip php7.0-soap php7.0-mbstring fail2ban php7.0-json php7.0-iconv php7.0-tokenizer pcre2-utils

sudo apt-get install -y ruby ruby-dev build-essential zlib1g-dev openjdk-8-jre

# P.42 The Art of Monitoring
wget https://github.com/riemann/riemann/releases/download/0.2.14/riemann_0.2.14_all.deb
sudo dpkg -i riemann_0.2.14_all.deb

sudo systemctl enable riemann
sudo systemctl start riemann 

# P. 44  Install ruby gem tools
sudo gem install --no-ri --no-rdoc riemann-tools

# epub 34%
# Installing collectd basic plugins for metric collection
sudo sudo add-apt-repository -y ppa:collectd/collectd-5.5
sudo apt-get update
sudo apt-get -y install collectd

git clone https://github.com/jhajek/commands
sudo cp ~/commands/cnf/collectd/collectd.d/*.conf /etc/collectd/collectd.conf.d/
sudo cp ~/commands/cnf/collectd/collectd.conf /etc/collectd/
sudo cp -R ~/commands/cnf/riemann/* /etc/riemann

sudo systemctl enable collectd
sudo systemctl start collectd
sudo systemctl restart riemann
# End of collectd and riemann install

sudo systemctl enable mysql.service
sudo systemctl start mysql.service
sudo systemctl enable nginx.service
sudo systemctl restart nginx.service

# Streamlined the git cloning and tracking of Moodle into one line
# https://docs.moodle.org/32/en/Installation_quick_guide#Install_Moodle
git clone -b MOODLE_32_STABLE git://git.moodle.org/moodle.git

# Create datadir in a not web-accessible directory
sudo mkdir /var/moodledata
sudo chown www-data:www-data /var/moodledata
sudo chmod 0777 /var/moodledata

# Delete default welcome page
sudo rm /var/www/html/index.nginx-debian.html
# Copy files from Git Repo to default /var/www/html/moodle
sudo mv ~/moodle/* /var/www/html/

#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails
sudo sed -i "s/bantime=600/bantime=-1/g" /etc/fail2ban/jail.conf
sudo systemctl enable fail2ban
sudo service fail2ban restart

# Enable Firewall
# https://serverfault.com/questions/809643/how-do-i-use-ufw-to-open-ports-on-ipv4-only
sudo ufw enable
ufw allow proto tcp to 0.0.0.0/0 port 22
ufw allow proto tcp to 0.0.0.0/0 port 80
ufw allow proto tcp to 0.0.0.0/0 port 443

# Mariadb create user and tables commands from https://github.com/jhajek/commands.git
cd ~
chmod +x ~/commands/cnf/cnf.sh
chmod +x ~/commands/cnf/db.sh
chmod +x ~/commands/cnf/cnf.sh
# Added the mariadb my.cnf configs for creating Barracuda
sudo ~/commands/cnf/db.sh
# Restart mariadb service after adding custom .my.cnf
sudo systemctl restart mysql.service

# https://stackoverflow.com/questions/8055694/how-to-execute-a-mysql-command-from-a-shell-script
# This section uses the user environment variables declared in packer json build template
# #USERPASS and $BKPASS
sudo mysql -u root -e "CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

sudo mysql -u root -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO moodleuser@localhost IDENTIFIED BY '$USERPASS'; flush privileges;"

# Create a user that has privilleges just to do a mysqldump backup
# http://www.fromdual.com/privileges-of-mysql-backup-user-for-mysqldump
sudo mysql -u root -e "CREATE USER 'backup'@'localhost' IDENTIFIED BY '$BKPASS'; GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER, LOCK TABLES ON *.* TO 'backup'@'localhost';"

# Chown webserver files
sudo chown -R www-data:www-data /var/www/html/

# Running CLI config setup of Moodle
sudo -u www-data /usr/bin/php /var/www/html/admin/cli/install.php --chmod=2770 --lang=en --wwwroot=http://127.0.0.1 --dataroot=/var/moodledata/ --dbtype=mariadb --dbhost=127.0.0.1 --dbuser=moodleuser --dbpass=$USERPASS --fullname="Moodle Research Project" --shortname="M2" --adminuser=adminjrh --adminpass=$ADMINPASS --non-interactive --agree-license

# Copy the pre-configured nginx conf to the right location
sudo cp -v ~/commands/moodle/nginx/default /etc/nginx/sites-enabled/
# Copy the pre-configured php.ini to the correct location
sudo cp -v ~/commands/moodle/php-fpm/php.ini /etc/php/7.0/fpm/
# Add xsendfile directive to the moodle config.php
chmod +x ~/commands/moodle/config/add-xsendfile.sh
sudo ~/commands/moodle/config/add-xsendfile.sh
sudo systemctl restart nginx

# Setting etc/cron.dailey for moodle
sudo cp -v ~/commands/backup/moodle-five-min-cron /etc/cron.d/
sudo chmod +x /etc/cron.d/moodle-five-min-cron
sudo cp -v ~/commands/backup/mysqldump-daily /etc/cron.daily/
sudo chmod +x /etc/cron.daily/mysqldump-daily
sudo /etc/cron.daily/mysqldump-daily
sudo cp -v ~/commands/backup/moodle-data-dir-backup /etc/cron.daily/
sudo chmod +x /etc/cron.daily/moodle-data-dir-backup
sudo /etc/cron.daily/moodle-data-dir-backup
sudo cp -v ~/commands/backup/moodle-www-backup /etc/cron.daily/
sudo chmod +x /etc/cron.daily/moodle-www-backup
sudo /etc/cron.daily/moodle-www-backup

# Change the timezone in php.ini
# http://php.net/manual/en/timezones.america.php
sudo sed -i "s/\;date.timezone =/date.timezone = America\/Chicago/g" /etc/php/7.0/fpm/php.ini
# https://docs.moodle.org/33/en/Nginx 
sudo sed -i "s/\;security.limit_extensions = .php .php3 .php4 .php5 .php7/security.limit_extensions = .php/g" /etc/php/7.0/fpm/pool.d/www.conf

# Restart Nginx after making changes to PHP
sudo systemctl restart nginx.service

