# Pre-steps to take
In order for the host system to send envoronment variables to the guest Vm being built you have to explicitly declare them on the command line before you issue a ```Packer build``` command.

This is how we are passing passwords in securely.

For example:

[https://marcofranssen.nl/packer-io-machine-building-and-provisioning-part-2/](https://marcofranssen.nl/packer-io-machine-building-and-provisioning-part-2/)

### Windows command line/Powershell
```set DB_NAME=mydatabase```

### Linux shell
```DB_NAME=mydatabase```