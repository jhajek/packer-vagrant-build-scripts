#!/bin/bash 
set -e
set -v

# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is vagrant
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant

# Installing Vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys
echo "All Done!"

##################################################
# Add User customizations below here
##################################################

sudo apt-get update
sudo apt-get install -y nginx fail2ban git

## enable firewall

ufw --force enable
ufw allow proto tcp to 0.0.0.0/0 port 22
ufw allow proto tcp to 0.0.0.0/0 port 80
ufw allow proto tcp to 0.0.0.0/0 port 443

# set the /etc/hosts file to match hostname
echo "$LBIP     lb     lb.class.edu"   | sudo tee -a /etc/hosts
echo "$WSIP1    ws1    ws1.class.edu"  | sudo tee -a /etc/hosts
echo "$WS2IP     ws2  ws2.class.edu"   | sudo tee -a /etc/hosts
echo "$WS3IP     ws3  ws3.class.edu"   | sudo tee -a /etc/hosts
echo "$REDIP     redis  redis.class.edu" | sudo tee -a /etc/hosts
echo "$MMIP     mm  mm.class.edu" | sudo tee -a /etc/hosts
echo "$MS1IP     ms1  ms1.class.edu" | sudo tee -a /etc/hosts
echo "$MS2IP     ms2  ms2.class.edu" | sudo tee -a /etc/hosts
echo "$MS3IP     ms3  ms3.class.edu" | sudo tee -a /etc/hosts
sudo hostnamectl set-hostname lb

# Nginx configurations
# https://nginx.org/en/docs/beginners_guide.html
# https://dev.to/guimg/how-to-serve-nodejs-applications-with-nginx-on-a-raspberry-jld
sudo cp ./hajek/itmt-430/fullstack/nginx-ws/default /etc/nginx/sites-enabled
sudo systemctl daemon-reload
sudo systemctl reload nginx

# Using Ubuntu
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo systemctl enable nginx
sudo systemctl start nginx
sudo npm install pm2@latest -g
# sudo pm2 startup systemd
# This line is the output of the above command
# https://pm2.keymetrics.io/docs/usage/startup/
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant

###############################################################################
# Replace any occurance of hajek with the name of your own private repository #
###############################################################################

mkdir /home/vagrant/project
sudo chown -R vagrant:vagrant ~/hajek

# Change ownership of PM2 service that auto-starts our NojeJS app
sudo chown -R vagrant:vagrant /home/vagrant/.pm2
cp ./hajek/itmt-430/fullstack/nginx-ws/app.js /home/vagrant/project
# Change the ownership of the NodeJS application files
sudo chown -R vagrant:vagrant /home/vagrant/project
pm2 start /home/vagrant/project/app.js
pm2 save
sudo chown -R vagrant:vagrant /home/vagrant/.pm2

# You could add a line to remove the private key and the extranious code from the GitHub repo here
sudo rm -v id_*


# https://nodejs.org/en/docs/guides/getting-started-guide/
