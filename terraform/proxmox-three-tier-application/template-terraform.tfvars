pm_api_url          = ""                             # URL of your Proxmox cluster
pm_api_token_id     = ""                             # This is an API token you have previously created for a specific user
pm_api_token_secret = ""                             # This is a uuid that is only available when initially creating the token 
pm_log_enable       = true                           # Optional; defaults to false) Enable debug logging, see the section below for logging details
pm_parallel         = 4                              # (Optional; defaults to 4) Allowed simultaneous Proxmox processes (e.g. creating resources).
pm_timeout          = 600                            # (Optional; defaults to 300) Timeout value (seconds) for proxmox API calls.
pm_log_file         = "terraform-plugin-proxmox.log" # (Optional; defaults to terraform-plugin-proxmox.log) If logging is enabled, the log file the provider will write logs to.

yourinitials_lb = "" # Your initials or Hawk ID to add to the vms so they have a unique name
yourinitials_ws = "" # Your initials or Hawk ID to add to the vms so they have a unique name
yourinitials_db = "" # Your initials or Hawk ID to add to the vms so they have a unique name
numberofvms        = 1
numberofvms-ws     = 1
desc-lb         = ""                    # What is the purpose of the TF template
desc-ws         = ""                    # What is the purpose of the TF template
desc-db         = ""                    # What is the purpose of the TF template
target_node        = ""                    # Promox node to provision VMs
template_to_clone-lb  = ""                    # The name of the template to clone
template_to_clone-ws  = ""                    # The name of the template to clone
template_to_clone-db  = ""                    # The name of the template to clone
memory             = 4096                  # Memory size of a VM
cores              = 1                     # vCPU = cores * sockets
sockets            = 1                     # vCPU = cores * sockets
storage            = ""                    # Which storage pool to use - example: local, local-lvm, disk1, etc
disk_size          = "50G"                 # Disk size of a VM - min size must equal to the disk size of your clone image
data_disk_size     = "100G"                # Data disk that can be attached to the launched instance
keypath            = "name-of-private-key" # The path to the private key you need to communicate with your instances
consulip           = "192.168.182.33"                    # IP address of consul master server