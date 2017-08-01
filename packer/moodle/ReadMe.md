# Pre-steps to take
In order for the host system to send envoronment variables to the guest Vm being built you have to explicitly declare them on the command line before you issue a ```Packer build``` command.

This is how we are passing passwords in securely.

[https://www.packer.io/docs/templates/user-variables.html](https://www.packer.io/docs/templates/user-variables.html)

### What we need to set
```packer build -var 'DBPASS=rootpasswordhere' -var 'USERPASS=moodledatabaseuserpasswordhere' -var 'BKPASS='backupuserdatabasepasswordhere' ubuntu-16042-moodle32.json```

This way we can securely build the entire moodle system, deploy it and when building it pass in passwords via environment variables