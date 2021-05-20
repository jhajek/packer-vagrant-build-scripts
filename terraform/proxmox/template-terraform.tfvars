pm_api_url  = "https://x.x.x.x:8006/api2/json" #URL of your Proxmox cluster
pm_user     = "pam"                              #Username of your Proxmox cluster
pm_password = "pass"                      #Password of your Proxmox cluster


desc              = "ITMT Class" #What is the purpose of the TF template
target_node       = "nameofnode"                     #Promox node to provision VMs
template_to_clone = "template"    #The name of the template to clone
memory            = 4096                       #Memory size of a VM
cores             = 2                          #vCPU = cores * sockets
sockets           = 1                          #vCPU = cores * sockets
storage           = "local-lvm"                #Which storage pool to use - example: local, local-lvm, disk1, etc
disk_size         = "10G"                      #Disk size of a VM - min size must equal to the disk size of your clone image