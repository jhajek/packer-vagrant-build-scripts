#!/bin/bash 
set -e
set -v

# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is vagrant
# http://chrisbalmer.io/vagrant/2015/07/02/build-rhel-centos-7-vagrant-box.html
# Read this bug track to see why this line below was the source of a lot of trouble.... 
# https://github.com/mitchellh/vagrant/issues/1482
#echo "Defaults requiretty" | sudo tee -a /etc/sudoers.d/init-users
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant

# Install Elrepo - The Community Enterprise Linux Repository (ELRepo) - http://elrepo.org/tiki/tiki-index.php
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sudo yum install -y epel-release # https://wiki.centos.org/AdditionalResources/Repositories
sudo yum makecache fast

# Install base dependencies -  Centos 7 mininal needs the EPEL repo in the line above and the package daemonize
sudo yum update -y
sudo yum install -y wget unzip vim git java-1.7.0-openjdk daemonize python-setuptools

# Installing Graphite packages on Centos P.131
sudo yum install -y python-whisper python-carbon

# P. 132 - Creating new graphite users
sudo groupadd _graphite 
sudo useradd -c "Carbon daemons" -g _graphite -d /var/lib/graphite -M -s /sbin/nologin _graphite

sudo mv /var/lib/carbon /var/lib/graphite 
sudo chown -R _graphite:_graphite /var/lib/graphite

sudo chown -R _graphite:_graphite /var/log/carbon
sudo userdel carbon

# P.135 - Listing 4.14: Install Graphite-API prerequisite packages on RedHat
sudo yum install -y python-pip gcc libffi-devel cairo-devel libtool libyaml-devel python-devel
# P.135 - Listing 4.15: Installing Graphite-API via pip
pip install -U six pyparsing websocket urllib3 
sudo pip install graphite-api gunicorn

# P. 137 - Listing4.19: CreatingtheGrafanaYumrepository
sudo touch /etc/yum.repos.d/grafana.repo



#http://superuser.com/questions/745881/how-to-authenticate-to-a-vm-using-vagrant-up
mkdir /home/vagrant/.ssh
wget --no-check-certificate \
    'https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub' \
    -O /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
chmod -R go-rwsx /home/vagrant/.ssh

# Due to needing a tty to run sudo, this install command adds all the pre-reqs to build the virtualbox additions
sudo yum install -y kernel-devel-`uname -r` gcc binutils make perl bzip2

# Fetch and install the Riemann RPM
wget https://aphyr.com/riemann/riemann-0.2.11-1.noarch.rpm
sudo rpm -Uvh riemann-0.2.11-1.noarch.rpm

# Enable to Riemann service to start on boot and start the service
sudo systemctl enable riemann
sudo systemctl start riemann

# P. 44  Install ruby gem tool, Centos 7 has Ruby 2.x as the default
sudo yum install -y ruby ruby-devel gcc libxml2-devel
sudo gem install --no-ri --no-rdoc riemann-tools

# Adding firewall rules for riemann - Centos 7 uses firewalld (Thanks Lennart...)
# http://serverfault.com/questions/616435/centos-7-firewall-configuration
sudo firewall-cmd --zone=public --add-port=5555/tcp --permanent
sudo firewall-cmd --zone=public --add-port=5556/udp --permanent
# Websockets are TCP... for now - http://stackoverflow.com/questions/4657033/javascript-websockets-with-udp
sudo firewall-cmd --zone=public --add-port=5557/tcp --permanent

echo "All Done!"