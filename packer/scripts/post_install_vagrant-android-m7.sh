#!/bin/bash 
set -e
set -v


##################################################
# https://wiki.lineageos.org/devices/m7/build
##################################################

cd ~/android/lineage
~/bin/repo init -u https://github.com/LineageOS/android.git -b cm-14.1
