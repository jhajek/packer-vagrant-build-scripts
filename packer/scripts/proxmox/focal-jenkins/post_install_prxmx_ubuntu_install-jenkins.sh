#!/bin/bash 
set -e
set -v

# Install Jenkins LTS by adding Jenkins repo
# https://pkg.jenkins.io/debian-stable/
sudo apt-get update
sudo apt-get install -y openjdk-11-jre openjdk-8-jdk
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
     sudo apt-get update
  sudo apt-get install -y jenkins

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins


