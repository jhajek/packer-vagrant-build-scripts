# packer-vagrant-build-scripts
This is a repository to store sample packer and vagrant build scrpts

Packer 1.1.1  [packer.io](http://packer.io "packer")
Vagrant 1.8.4, 1.9.1, and 2.0.0 tested [vagrantup.com](http://vagrantup.com "Vagrant") also needed to install: ```vagrant plugin vagrant-vbguest```
VirtualBox 5.1.4 and 5.1.26 tested
Operating systems used and tested:
*  MacOS 10.12.2
*  Windows 10 
*  Ubuntu Linux 16.04 

# Build everything
There is a build-everything-riemann.sh and .ps1 (powershell) script that can be run from the **scripts** folder (needs to be run from their due to relative paths hardcoded.  This will build riemann a, b, an mc for Ubuntu and for Centos)
There is also a build-everything-vanilla.sh and .ps1 for building Ubuntu 14.04.5, 16.04.4jhajek, and Centos 7-1611 vanilla VirtualBox .ovf and Vagrant box 