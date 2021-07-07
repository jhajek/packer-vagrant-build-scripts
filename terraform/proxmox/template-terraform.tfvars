pm_api_url  = ""                              # URL of your Proxmox cluster
pm_api_token_id = ""                          # This is an API token you have previously created for a specific user
pm_api_token_secret = ""                      # This is a uuid that is only available when initially creating the token 
pm_log_enable =  true                         # Optional; defaults to false) Enable debug logging, see the section below for logging details
pm_parallel = 4                               # (Optional; defaults to 4) Allowed simultaneous Proxmox processes (e.g. creating resources).
pm_timeout = 300                              # (Optional; defaults to 300) Timeout value (seconds) for proxmox API calls.
pm_log_file = "terraform-plugin-proxmox.log"  # (Optional; defaults to terraform-plugin-proxmox.log) If logging is enabled, the log file the provider will write logs to.

yourinitials      = ""                        # Your initials or Hawk ID to add to the vms so they have a unique name
numberofvms       = 3
desc              = ""                         # What is the purpose of the TF template
target_node       = ""                         # Promox node to provision VMs
template_to_clone = ""                         # The name of the template to clone
memory            = 4096                       # Memory size of a VM
cores             = 2                          # vCPU = cores * sockets
sockets           = 1                          # vCPU = cores * sockets
storage           = ""                         # Which storage pool to use - example: local, local-lvm, disk1, etc
disk_size         = "20G"                      # Disk size of a VM - min size must equal to the disk size of your clone image
additional_wait	  = 60	                       # The amount of time in seconds to wait between creating the VM and powering it up.
keypath           = "name-of-private-key"      # The path to the private key you need to communicate with your instances
clone_wait        = 60                         # Provider will wait clone_wait/2 seconds after a clone operation and clone_wait seconds after an UpdateConfig operation.
consulip          = ""                         # IP address of consul master server