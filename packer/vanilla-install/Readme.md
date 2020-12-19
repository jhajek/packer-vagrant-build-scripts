# Vanilla Install

These are the commands and variables to create proxmox templates

## Commands

```bash
packer build -var "ip=10.100.0.2" -var "prxmx-url=https://192.168.1.200:8006/api2/json" -var "storagepool=datadisk1" -var "storagepooltype=lvm" -var "vmname=ubuntu-18045-user1" -var "uname=root@pam" -var "password=cluster" .\ubuntu18045-vanilla-proxmox-build-on-linux.json
```
