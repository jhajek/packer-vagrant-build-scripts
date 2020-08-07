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

# Install Elrepo - The Community Enterprise Linux Repository (ELRepo) - http://elrepo.org/tiki/tiki-index.php
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sudo yum install -y epel-release # https://wiki.centos.org/AdditionalResources/Repositories
sudo yum makecache fast

# Install base dependencies -  Centos 7 mininal needs the EPEL repo in the line above and the package daemonize
sudo yum update -y
sudo yum install -y wget unzip vim git java-1.8.0-openjdk daemonize curl collectd
# Due to needing a tty to run sudo, this install command adds all the pre-reqs to build the virtualbox additions
sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2 python3 python3-pip python3-setuptools

###############################################################################################################
# firewalld additions to make CentOS and riemann to work
###############################################################################################################
# Adding firewall rules for riemann - Centos 7 uses firewalld (Thanks Lennart...)
# http://serverfault.com/questions/616435/centos-7-firewall-configuration
sudo firewall-cmd --zone=public --add-port=5555/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5556/udp --permanent
# Websockets are TCP... for now - http://stackoverflow.com/questions/4657033/javascript-websockets-with-udp
sudo firewall-cmd --zone=public --add-port=5557/tcp --permanent
###############################################################################################################

###############################################################################################################
# Fetch and install the Riemann RPM
###############################################################################################################
wget https://github.com/riemann/riemann/releases/download/0.3.5/riemann-0.3.5-1.noarch-EL7.rpm
sudo rpm -Uvh riemann-0.3.5-1.noarch-EL7.rpm

# Enable to Riemann service to start on boot and start the service
sudo systemctl enable riemann
sudo systemctl start riemann

# P. 44  Install ruby gem tool, Centos 7 has Ruby 2.x as the default
sudo yum install -y ruby ruby-devel gcc libxml2-devel
sudo gem install --no-ri --no-rdoc riemann-tools

###############################################################################################################
### Class cusomtizations
# Installing Graphite packages on Centos P.131
###############################################################################################################
sudo yum install -y python-whisper python-carbon

# P. 132 - Creating new graphite users
sudo groupadd _graphite 
sudo useradd -c "Carbon daemons" -g _graphite -d /var/lib/graphite -M -s /sbin/nologin _graphite

# Listing4.8: Changingtheownershipof/var/log/carbon
sudo mv /var/lib/carbon /var/lib/graphite 
sudo chown -R _graphite:_graphite /var/lib/graphite

# Listing4.9: Removingthecarbonuser
sudo chown -R _graphite:_graphite /var/log/carbon
sudo userdel carbon

# P.135 - Listing 4.14: Install Graphite-API prerequisite packages on RedHat
sudo yum install -y python-pip gcc libffi-devel cairo-devel libtool libyaml-devel python-devel

# P.135 - Listing 4.15: Installing Graphite-API via pip
sudo pip install -U six pyparsing websocket urllib3 
sudo pip install graphite-api gunicorn

# P. 137 - Listing 4.19: Creating the Grafana Yum repository
sudo touch /etc/yum.repos.d/grafana.repo

# P.138 - Listing 4.20: Yum repository definition for Grafana
# http://superuser.com/questions/351193/echo-multiple-lines-of-text-to-a-file-in-bash
# http://docs.grafana.org/installation/rpm/
cat > grafana.repo <<'EOT'
[grafana]
name=grafana
baseurl=https://packagecloud.io/grafana/stable/el/6/$basearch
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packagecloud.io/gpg.key https://grafanarel.s3.amazonaws.com/RPM-GPG-KEY-grafana
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt  
EOT

# NOTE Repace the 6 above with your RedHat version, for example 7 for RHEL 7.
cat ./grafana.repo | sudo tee -a /etc/yum.repos.d/grafana.repo

# p.138 - Listing 4.21: Installing Grafana via Yum
sudo yum install -y grafana

# P.153 - Listing 4-39 - Create empty conf file to avoid error
sudo cp -v carbon.conf /etc/carbon
sudo touch /etc/carbon/storage-aggregation.conf

sudo cp -v storage-schemas.conf /etc/carbon

# Listing 4.50 move the carbon cache demon systemd service file
sudo cp -v carbon-cache@.service /lib/systemd/system/carbon-cache@.service

# Listing 4.51: Enabling and starting the systemd Carbon Cache daemons
sudo systemctl enable carbon-cache@1.service 
sudo systemctl enable carbon-cache@2.service
sudo systemctl start carbon-cache@1.service
sudo systemctl start carbon-cache@2.service

# Listing 4.52 move carbon-relay systemd demon service definition
sudo cp -v carbon-relay@.service /lib/systemd/system/carbon-relay@.service

# Listing 4.53: Enabling and starting the systemd Carbon relay daemon
sudo systemctl enable carbon-relay@1.service
sudo systemctl start carbon-relay@1.service

# Listing 4.54: Remove the old systemd unit files for Carbon
sudo rm -f /lib/systemd/system/carbon-relay.service
sudo rm -f /lib/systemd/system/carbon-cache.service

# P. 162 Copy the default graphite-api.yaml file overwritting the default one installed
sudo cp -v graphite-api.yaml /etc/graphite-api.yaml

# Listing 4.56: Creating the /var/lib/graphite/api_search_indexfile
sudo touch /var/lib/graphite/api_search_index
sudo chown _graphite:_graphite /var/lib/graphite/api_search_index

# Listing 4.58: Systemd script for Graphite-API
sudo cp -v graphite-api.service /lib/systemd/system/graphite-api.service

# Listing 4.60: Enabling and starting the systemd Graphite-API daemons
sudo systemctl enable graphite-api.service
sudo systemctl start graphite-api.service

echo "All Done!"