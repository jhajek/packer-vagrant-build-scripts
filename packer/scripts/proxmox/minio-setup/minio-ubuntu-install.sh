#!/bin/bash

##################################################
# https://min.io/download#/linux
##################################################
sudo apt-get update
# Installing ZFS library
sudo apt-get install -y zfsutils-linux

wget https://dl.min.io/server/minio/release/linux-amd64/minio_20210730000200.0.0_amd64.deb
dpkg -i minio_20210730000200.0.0_amd64.deb
