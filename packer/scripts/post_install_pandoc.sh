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
sudo sed -i "s/bantime=600/bantime=-1/g" /etc/fail2ban/jail.conf
sudo systemctl enable fail2ban
sudo service fail2ban restart

# User add customizations here -- keep the above code
sudo apt-get update && sudo apt-get -y dist-upgrade
sudo apt-get -y install texlive texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra
wget http://packages.sil.org/sil.gpg
sudo apt-key add sil.gpg
sudo apt-add-repository -y "deb http://packages.sil.org/ubuntu/ $(lsb_release -sc) main"
sudo apt-get update
sudo apt-get -y install fonts-sil-charis

wget https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb
sudo dpkg -i pandoc-1.19.2.1-1-amd64.deb

git clone https://github.com/jhajek/Linux-text-book-part-1.git
