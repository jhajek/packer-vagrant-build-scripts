#!/bin/sh -x

#update 
apt-get -y update
apt-get -y install wget git curl gnupg software-properties-common tzdata
echo "America/Chicago" > /etc/timezone
wget https://github.com/jgm/pandoc/releases/download/2.2.2.1/pandoc-2.2.2.1-1-amd64.deb
dpkg -i pandoc-2.2.2.1-1-amd64.deb
apt-get -y install texlive texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra texlive-xetex


wget http://packages.sil.org/sil.gpg
apt-key -y add sil.gpg
apt-add-repository -y "deb http://packages.sil.org/ubuntu/ $(lsb_release -sc) main"
apt-get -y update
apt-get -y install fonts-sil-charis

apt-get -y install fonts-inconsolata
fc-cache -fv

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
echo "deb https://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
apt-get -y update
apt-get -y install openjdk-8-jdk jenkins