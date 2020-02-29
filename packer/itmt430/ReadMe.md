# Pre-steps to take

In order for the host system to send environment variables to the guest vm being built you have to explicitly declare them on the command line before you issue a ```packer build``` command.

This is how we are passing passwords/RSA keys securely.

[https://www.packer.io/docs/templates/user-variables.html](https://www.packer.io/docs/templates/user-variables.html)

## What we need to set username and passwords securely in Packer

1) Issue the command inside of the folder, ```cp variables-sample.json variables.json```
    1) The ```variables.json``` file contains key value pairs of variables and passwords to be passed into the provisioner shell script.
    1) This renames the file ```variables-sample.json``` to ```variables.json```  (There is an entry in the `.gitignore` so you cannot accidentally `git push` your passwords).
1) Edit the ```variables.json``` file replacing default values with your own
1) Issue the command to begin the install with password, usernames, and RSA private key properly seeded:

```bash
packer build --var-file=./variables.json ubuntu18044-itmt430-database.json
packer build --var-file=./variables.json ubuntu18044-itmt430-webserver.json
```

This way we can securely build the system, deploy it and when building it pass in passwords via environment variables

## Webserver contents

1) This application has an Nginx webserver running on port 80.  
1) It has a Nodejs Hello World application running on port 3000.
1) It has an Nginx route to the Nodejs app located at `/app`

## Database contents

1) System will create a `.my.cnf` file which allows for password-less authentication
1) System will pre-seed MariaDB or MySQL root password
