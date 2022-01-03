#!/bin/bash 
set -e
set -v

# Install Android and Jenkins Java Dependencies
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y android-sdk

