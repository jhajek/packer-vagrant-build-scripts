#!/bin/bash 
set -e
set -v

# Install dependencies to create a jenkins system
sudo apt-get update

# Install for Pandoc dependencies to build textbooks and guides
sudo apt-get install -y texlive texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra texlive-xetex texlive-font-utils librsvg2-bin

wget http://packages.sil.org/sil.gpg
sudo apt-key add sil.gpg
sudo apt-add-repository "deb http://packages.sil.org/ubuntu/ $(lsb_release -sc) main"
sudo apt-get install -y fonts-sil-charis fonts-inconsolata
sudo fc-cache -fv

wget https://github.com/jgm/pandoc/releases/download/2.16.2/pandoc-2.16.2-1-amd64.deb
sudo dpkg -i pandoc-2.16.2-1-amd64.deb

