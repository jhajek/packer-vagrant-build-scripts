#!/bin/bash 
set -e
set -v

##################################################
# Due to needing a tty to run sudo, this install command adds all the pre-reqs to build the virtualbox additions
sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2 vim wget git rsync
###############################################################################################################
# firewalld additions to make CentOS and riemann to work
###############################################################################################################
# Adding firewall rules for riemann - Centos 7 uses firewalld (Thanks Lennart...)
# http://serverfault.com/questions/616435/centos-7-firewall-configuration
# Websockets are TCP... for now - http://stackoverflow.com/questions/4657033/javascript-websockets-with-udp
sudo firewall-cmd --permanent --zone=public --add-port=5555/tcp --permanent
sudo firewall-cmd --permanent --zone=public --add-port=5556/udp --permanent
sudo firewall-cmd --permanent --zone=public --add-port=5557/tcp --permanent
sudo firewall-cmd --permanent --zone=public --add-port=8888/tcp --permanent
sudo firewall-cmd --permanent --zone=public --add-port=3000/tcp --permanent
sudo firewall-cmd --reload
###############################################################################################################
# P. 128 - 129
sudo yum install -y epel-release
sudo yum install -y python3 python3-pip python3-setuptools python3-devel gcc libffi-devel cairo-devel libtool libyaml-devel
sudo yum install -y python-six pyparsing python-urllib3
sudo yum install -y python-whisper python-carbon python-gunicorn graphite-api

#P. 130 - 131
sudo groupadd _graphite
sudo useradd -c "Carbon daemons" -g _graphite -d /var/lib/graphite -M -s /sbin/nologin _graphite
sudo mv /var/lib/carbon /var/lib/graphite
sudo chown -R _graphite:_graphite /var/lib/graphite
sudo chown -R _graphite:_graphite /var/log/carbon
sudo userdel carbon

# P. 135 - Installing Grafana rpm package
wget https://dl.grafana.com/oss/release/grafana-7.1.5-1.x86_64.rpm
sudo yum install -y grafana-7.1.5-1.x86_64.rpm
##################################################
# cloning source code examples for the book
git clone https://github.com/turnbullpress/aom-code.git

# P.137
sudo cp -v /home/vagrant/aom-code/4/graphite/carbon.conf /etc/carbon/
# P.157
sudo rm -f /lib/systemd/system/carbon-relay.service
sudo rm -f /lib/systemd/system/carbon-cache.service
# No longer needed
#sudo cp -v /home/vagrant/aom-code/4/graphite/carbon-cache@.service /lib/systemd/system/
#sudo cp -v /home/vagrant/aom-code/4/graphite/carbon-relay@.service /lib/systemd/system/
# P.159
sudo cp -v /home/vagrant/aom-code/4/graphite/graphite-api.yaml /etc/
sudo touch /var/lib/graphite/api_search_index
# No longer needed
#sudo touch /etc/carbon/storage-aggregation.conf
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