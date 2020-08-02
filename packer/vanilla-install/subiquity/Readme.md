# What is Subiquity

subiquity is the Ubuntu server’s new automated installer, which was introduced in 18.04. It is the server counterpart of ubiquity installer used by desktop live CD installation.

Autoinstallation lets you answer all those configuration questions ahead of time with autoinstall config and lets the installation process run without any external interaction. The autoinstall config is provided via cloud-init configuration. Values are taken from the config file if set, else default values are used.

There are multiple ways to provide configuration data for cloud-init. Typically user config is stored in user-data and cloud specific config in meta-data file. The list of supported cloud datasources can be found in cloudinit docs. Since packer builds it locally, data source is NoCloud in our case and the config files will served to the installer over http.

[https://beryju.org/blog/automating-ubuntu-server-20-04-with-packer](https://beryju.org/blog/automating-ubuntu-server-20-04-with-packer "Subiquity 20.04")

[https://beryju.org/blog/automating-ubuntu-server-20-04-with-packer](https://beryju.org/blog/automating-ubuntu-server-20-04-with-packer "packer ubuntu 2004)