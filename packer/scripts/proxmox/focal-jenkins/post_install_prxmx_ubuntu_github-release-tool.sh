#!/bin/bash 
set -e
set -v

##############################################################################################
# Download and install the github release executable for adding compiled binaries to 
# the release tab in GitHub
##############################################################################################
wget https://github.com/github-release/github-release/releases/download/v0.10.0/linux-amd64-github-release.bz2
bzip2 -dv linux-amd64-github-release.bz2
chmod +x linux-amd64-github-release
mv -v linux-amd64-github-release /usr/local/bin/github-release
