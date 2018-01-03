#!/bin/bash 
set -e
set -v


# Update the system and distribution
 apt-get update -y 
 #  apt-get -y upgrade

# https://dba.stackexchange.com/questions/59317/install-mariadb-10-on-ubuntu-without-prompt-and-no-root-password
# http://dba.stackexchange.com/questions/35866/install-mariadb-without-password-prompt-in-ubuntu?newreg=426e4e37d5a2474795c8b1c911f0fb9f
# From <http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423> 
export DEBIAN_FRONTEND=noninteractive
echo "mariadb-server mysql-server/root_password password $DBPASS" |   debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password $DBPASS" |  debconf-set-selections

 apt-get install -y nginx php7.0 php7.0-fpm php7.0-mysql mariadb-server graphviz aspell php7.0-pspell php7.0-curl php7.0-gd php7.0-intl php7.0-mysql php7.0-xml php7.0-xmlrpc php7.0-ldap php7.0-zip php7.0-soap php7.0-mbstring php7.0-json php7.0-iconv php7.0-tokenizer pcre2-utils wget git

 apt-get install -y ruby ruby-dev build-essential zlib1g-dev openjdk-8-jre

# P.42 The Art of Monitoring
wget https://github.com/riemann/riemann/releases/download/0.2.14/riemann_0.2.14_all.deb
 dpkg -i riemann_0.2.14_all.deb

 systemctl enable riemann
 service riemann start 

# P. 44  Install ruby gem tools
 gem install --no-ri --no-rdoc riemann-tools

# epub 34%
# Installing collectd basic plugins for metric collection
#  add-apt-repository -y ppa:collectd/collectd-5.5
# apt-get update
 apt-get -y install collectd

 cp /tmp/commands/cnf/collectd/collectd.d/*.conf /etc/collectd/collectd.conf.d/
 cp /tmp/commands/cnf/collectd/collectd.conf /etc/collectd/
 cp -R /tmp/commands/cnf/riemann/* /etc/riemann

 systemctl enable collectd
 service collectd start
 service riemann start
# End of collectd and riemann install

 systemctl enable mysql.service
 service mysql start
 systemctl enable nginx.service
 service nginx start

# Streamlined the git cloning and tracking of Moodle into one line
# https://docs.moodle.org/32/en/Installation_quick_guide#Install_Moodle
git clone -b MOODLE_32_STABLE git://git.moodle.org/moodle.git /tmp/moodle

# Create datadir in a not web-accessible directory
 mkdir /var/moodledata
 chown www-data:www-data /var/moodledata
 chmod 0777 /var/moodledata

# Delete default welcome page
 rm /var/www/html/index.nginx-debian.html
# Copy files from Git Repo to default /var/www/html/moodle
 mv -v /tmp/moodle/* /var/www/html/

#http://www.fail2ban.org/wiki/index.php/MANUAL_0_8#Jails
# sed -i "s/bantime=600/bantime=-1/g" /etc/fail2ban/jail.conf
# systemctl enable fail2ban
# service fail2ban restart

# Enable Firewall
# https://serverfault.com/questions/809643/how-do-i-use-ufw-to-open-ports-on-ipv4-only
#  ufw enable
# ufw allow proto tcp to 0.0.0.0/0 port 22
# ufw allow proto tcp to 0.0.0.0/0 port 80
# ufw allow proto tcp to 0.0.0.0/0 port 443

# Mariadb create user and tables commands from https://github.com/jhajek/commands.git
chmod +x /tmp/commands/cnf/cnf.sh
chmod +x /tmp/commands/cnf/db.sh
chmod +x /tmp/commands/cnf/cnf.sh
# Added the mariadb my.cnf configs for creating Barracuda
 /tmp/commands/cnf/db.sh
# Restart mariadb service after adding custom .my.cnf
 service mysql restart

# https://stackoverflow.com/questions/8055694/how-to-execute-a-mysql-command-from-a-shell-script
# This section uses the user environment variables declared in packer json build template
# #USERPASS and $BKPASS
 mysql -u root -e "CREATE DATABASE moodle DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

 mysql -u root -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodle.* TO moodleuser@localhost IDENTIFIED BY '$USERPASS'; flush privileges;"

# Create a user that has privilleges just to do a mysqldump backup
# http://www.fromdual.com/privileges-of-mysql-backup-user-for-mysqldump
 mysql -u root -e "CREATE USER 'backup'@'localhost' IDENTIFIED BY '$BKPASS'; GRANT SELECT, SHOW VIEW, RELOAD, REPLICATION CLIENT, EVENT, TRIGGER, LOCK TABLES ON *.* TO 'backup'@'localhost';"

# Chown webserver files
 chown -R www-data:www-data /var/www/html/

# Running CLI config setup of Moodle
 /usr/bin/php /var/www/html/admin/cli/install.php --chmod=2770 --lang=en --wwwroot=http://127.0.0.1 --dataroot=/var/moodledata/ --dbtype=mariadb --dbhost=127.0.0.1 --dbuser=moodleuser --dbpass=$USERPASS --fullname="Moodle Research Project" --shortname="M2" --adminuser=adminjrh --adminpass=$ADMINPASS --non-interactive --agree-license

# Copy the pre-configured nginx conf to the right location
 cp -v /tmp/commands/moodle/nginx/default /etc/nginx/sites-enabled/
# Copy the pre-configured php.ini to the correct location
 cp -v /tmp/commands/moodle/php-fpm/php.ini /etc/php/7.0/fpm/
# Add xsendfile directive to the moodle config.php
chmod +x /tmp/commands/moodle/config/add-xsendfile.sh
 /tmp/commands/moodle/config/add-xsendfile.sh
 service nginx restart

# Setting etc/cron.dailey for moodle
 cp -v /tmp/commands/backup/moodle-five-min-cron /etc/cron.d/
 chmod +x /etc/cron.d/moodle-five-min-cron
 cp -v /tmp/commands/backup/mysqldump-daily /etc/cron.daily/
 chmod +x /etc/cron.daily/mysqldump-daily
 /etc/cron.daily/mysqldump-daily
 cp -v /tmp/commands/backup/moodle-data-dir-backup /etc/cron.daily/
 chmod +x /etc/cron.daily/moodle-data-dir-backup
 /etc/cron.daily/moodle-data-dir-backup
 cp -v /tmp/commands/backup/moodle-www-backup /etc/cron.daily/
 chmod +x /etc/cron.daily/moodle-www-backup
 /etc/cron.daily/moodle-www-backup

# Change the timezone in php.ini
# http://php.net/manual/en/timezones.america.php
 sed -i "s/\;date.timezone =/date.timezone = America\/Chicago/g" /etc/php/7.0/fpm/php.ini
# https://docs.moodle.org/33/en/Nginx 
 sed -i "s/\;security.limit_extensions = .php .php3 .php4 .php5 .php7/security.limit_extensions = .php/g" /etc/php/7.0/fpm/pool.d/www.conf

# Restart Nginx after making changes to PHP
 systemctl restart nginx.service

