#!/bin/bash 
set -e
set -v

# Install base dependencies -  Centos 7 mininal needs the EPEL repo in the line above and the package daemonize
sudo yum update -y
sudo yum install -y wget unzip vim git 

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
##################################################
# Change hostname and /etc/hosts
##################################################
cat << EOT >> /etc/hosts
# Nodes
192.168.33.110 riemanna riemanna.example.com
192.168.33.120 riemannb riemannb.example.com
192.168.33.100 riemannmc riemannmc.example.com
192.168.33.210 graphitea graphitea.example.com
192.168.33.220 graphiteb graphiteb.example.com
192.168.33.200 graphitemc graphitemc.example.com
192.168.33.150 ela1 ela1.example.com
192.168.33.160 ela2 ela2.example.com
192.168.33.170 ela3 ela3.example.com
192.168.33.180 logstash logstash.example.com
192.168.33.10 host1 host1.example.com
192.168.33.11 host2 host2.example.com
EOT

sudo hostnamectl set-hostname centos-graphiteb
##################################################
# Due to needing a tty to run sudo, this install command adds all the pre-reqs to build the virtualbox additions
sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2 vim
###############################################################################################################
# firewalld additions to make CentOS and riemann to work
###############################################################################################################
# Adding firewall rules for riemann - Centos 7 uses firewalld (Thanks Lennart...)
# http://serverfault.com/questions/616435/centos-7-firewall-configuration
# Websockets are TCP... for now - http://stackoverflow.com/questions/4657033/javascript-websockets-with-udp
sudo firewall-cmd --zone=public --add-port=5555/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5556/udp --permanent
sudo firewall-cmd --zone=public --add-port=5557/tcp --permanent
###############################################################################################################
# P. 128 - 129
sudo yum install -y epel-release
sudo yum install -y python3-setuptools
sudo yum install -y python-whisper python-carbon

#P. 130 - 131
sudo groupadd _graphite
sudo useradd -c "Carbon daemons" -g _graphite -d /var/lib/graphite -M -s /sbin/nologin _graphite
sudo mv /var/lib/carbon /var/lib/graphite
sudo chown -R _graphite:_graphite /var/lib/graphite
sudo chown -R _graphite:_graphite /var/log/carbon
sudo userdel carbon

# Install the pre-reqs needed for python based installation of carbon and whisper
# P. 133
sudo yum install -y python3 python3-pip python3-setuptools python3-devel gcc libffi-devel cairo-devel libtool libyaml-devel
python3 -m pip install --user six pyparsing websocket urllib3
python3 -m pip install --user graphite-api gunicorn

# P. 135 - Installing Grafana rpm package
wget https://dl.grafana.com/oss/release/grafana-7.1.5-1.x86_64.rpm
sudo yum install -y grafana-7.1.5-1.x86_64.rpm
##################################################
# cloning source code examples for the book
git clone https://github.com/turnbullpress/aom-code.git

sudo cp -v /home/vagrant/aom-code/4/graphite/graphite-api.service /lib/systemd/system/
# P.137
sudo cp -v /home/vagrant/aom-code/4/graphite/carbon.conf /etc/carbon/
# P.153
sudo cp -v /home/vagrant/aom-code/4/graphite/graphite-carbon.default /etc/default/graphite-carbon
# P.157
sudo rm -f /lib/systemd/system/carbon-relay.service
sudo rm -f /lib/systemd/system/carbon-cache.service
sudo cp -v /home/vagrant/aom-code/4/graphite/carbon-cache@.service /lib/systemd/system/
sudo cp -v /home/vagrant/aom-code/4/graphite/carbon-relay@.service /lib/systemd/system/
# P.159
sudo cp -v /home/vagrant/aom-code/4/graphite/graphite-api.yaml /etc/
sudo touch /var/lib/graphite/api_search_index
##################################################################################################
# Start Services
##################################################################################################
sudo systemctl enable carbon-cache@1.service
sudo systemctl enable carbon-cache@2.service
sudo systemctl start carbon-cache@1.service
sudo systemctl start carbon-cache@2.service

sudo systemctl enable carbon-relay@1.service
sudo systemctl start carbon-relay@1.service

sudo systemctl daemon-reload 
sudo systemctl enable graphite-api
sudo systemctl start graphite-api

sudo systemctl enable grafana-server
sudo systemctl start grafana-server


echo "All Done!"