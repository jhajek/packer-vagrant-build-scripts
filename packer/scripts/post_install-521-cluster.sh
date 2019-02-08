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
sudo mkdir -p /home/vagrant/.ssh
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

cat << EOT >> /home/vagrant/.bashrc 

########## Inserted by Jeremy
export JAVA_HOME=/usr
export HADOOP_HOME=/home/vagrant/hadoop-2.8.5
export PATH=$PATH:$HADOOP_HOME/bin:/$HADOOP_HOME/sbin:
export HADOOP_CLASSPATH=/usr/lib/jvm/java-8-openjdk-amd64/lib/tools.jar
EOT

# http://askubuntu.com/questions/493460/how-to-install-add-apt-repository-using-the-terminal
sudo apt-get update ; sudo apt-get install -y software-properties-common openjdk-8-jdk

sudo apt-get -y install pkgconf wget liblzo2-dev sysstat iotop vim libssl-dev libsnappy-dev libsnappy-java libbz2-dev libgcrypt11-dev zlib1g-dev lzop htop fail2ban

# Download Hadoop 2.8.5 source and extract tarbal
wget http://mirror.cc.columbia.edu/pub/software/apache/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz
tar -xvzf ~/hadoop-2.8.5.tar.gz

cat << EOT >> /etc/hosts

# Hadoop Datanodes
192.168.1.101 datanode1 datanode1.sat.iit.edu
192.168.1.102 datanode2 datanode2.sat.iit.edu
192.168.1.103 datanode3 datanode3.sat.iit.edu
192.168.1.104 datanode4 datanode4.sat.iit.edu
192.168.1.105 datanode5 datanode5.sat.iit.edu
#192.168.1.106 datanode6 datanode6.sat.iit.edu
192.168.1.106 mariadbserver mariadbserver.sat.iit.edu

# namenode
192.168.1.100 namenode namenode.sat.iit.edu
#riemannmc
10.101.0.2 riemann riemann.sat.iit.edu
EOT