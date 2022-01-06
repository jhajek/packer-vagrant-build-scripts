locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }
#################################################################
# This script builds a 3 tier app - https://www.ibm.com/in-en/cloud/learn/three-tier-architecture
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################

#################################################################
# Build for Ubuntu Focal 20.04 Nginx LoadBalancer
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################
source "proxmox-iso" "proxmox-focal-lb" {
  boot_command = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/", "<enter><wait>"]
  boot_wait    = "5s"
  cores        = "${var.NUMBEROFCORES}"
  node         = "${var.NODENAME}"
  username     = "${var.USERNAME}"
  token        = "${var.PROXMOX_TOKEN}"
  cpu_type     = "host"
  disks {
    disk_size         = "${var.DISKSIZE}"
    storage_pool      = "${var.STORAGEPOOL}"
    storage_pool_type = "lvm"
    type              = "virtio"
  }
  http_directory   = "subiquity/http"
  http_port_max    = 9200
  http_port_min    = 9001
  iso_checksum     = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  iso_urls         = ["http://mirrors.kernel.org/ubuntu-releases/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"]
  iso_storage_pool = "local"
  memory           = "${var.MEMORY}"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  os                       = "l26"
  proxmox_url              = "${var.URL}"
  insecure_skip_tls_verify = true
  unmount_iso              = true
  qemu_agent               = true
  cloud_init               = true
  cloud_init_storage_pool  = "local"
  ssh_password             = "vagrant"
  ssh_username             = "vagrant"
  ssh_port                 = 2222
  ssh_timeout              = "20m"
  ssh_wait_timeout         = "1800s"
  template_description     = "A Packer template to create an Nginx LoadBalancer"
  vm_name                  = "${var.LBNAME}"
}

#################################################################
# Build for Rocky Linux 8.5 Nginx Webserver
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################
source "proxmox-iso" "proxmox-rocky-ws" {
  boot_command    = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-85.ks<enter>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>"]
  boot_wait       = "10s"
  cores           = "${var.NUMBEROFCORES}"
  node            = "${var.NODENAME}"
  username        = "${var.USERNAME}"
  token           = "${var.PROXMOX_TOKEN}"
  cpu_type        = "host"
  scsi_controller = "virtio-scsi-pci"
  disks {
    disk_size         = "${var.DISKSIZE}"
    storage_pool      = "${var.STORAGEPOOL}"
    storage_pool_type = "lvm"
    type              = "virtio"
  }
  http_directory   = "./"
  http_port_max    = 9200
  http_port_min    = 9001
  iso_checksum     = "sha256:5a0dc65d1308e47b51a49e23f1030b5ee0f0ece3702483a8a6554382e893333c"
  iso_urls         = ["https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.5-x86_64-boot.iso"]
  iso_storage_pool = "local"
  memory           = "${var.MEMORY}"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  os                       = "l26"
  proxmox_url              = "${var.URL}"
  insecure_skip_tls_verify = true
  unmount_iso              = true
  qemu_agent               = true
  cloud_init               = true
  cloud_init_storage_pool  = "local"
  ssh_password             = "vagrant"
  ssh_username             = "vagrant"
  ssh_port                 = 22
  ssh_timeout              = "20m"
  ssh_wait_timeout         = "1800s"
  template_description     = "A Packer template to create 3 Nginx webservers"
  vm_name                  = "${var.WSNAME}"
}

#################################################################
# Build for Ubuntu Focal 20.04 Database Server
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################
source "proxmox-iso" "proxmox-focal-db" {
  boot_command = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/", "<enter><wait>"]
  boot_wait    = "5s"
  cores        = "${var.NUMBEROFCORES}"
  node         = "${var.NODENAME}"
  username     = "${var.USERNAME}"
  token        = "${var.PROXMOX_TOKEN}"
  cpu_type     = "host"
  disks {
    disk_size         = "${var.DISKSIZE}"
    storage_pool      = "${var.STORAGEPOOL}"
    storage_pool_type = "lvm"
    type              = "virtio"
  }
  http_directory   = "subiquity/http"
  http_port_max    = 9200
  http_port_min    = 9001
  iso_checksum     = "sha256:f8e3086f3cea0fb3fefb29937ab5ed9d19e767079633960ccb50e76153effc98"
  iso_urls         = ["http://mirrors.kernel.org/ubuntu-releases/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"]
  iso_storage_pool = "local"
  memory           = "${var.MEMORY}"
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  os                       = "l26"
  proxmox_url              = "${var.URL}"
  insecure_skip_tls_verify = true
  unmount_iso              = true
  qemu_agent               = true
  cloud_init               = true
  cloud_init_storage_pool  = "local"
  ssh_password             = "vagrant"
  ssh_username             = "vagrant"
  ssh_port                 = 2222
  ssh_timeout              = "20m"
  ssh_wait_timeout         = "1800s"
  template_description     = "A Packer template to create a Focal database"
  vm_name                  = "${var.DBNAME}"
}

build {
  ########################################################################################################################
  # This command tells Packer what to build -- these values are defined in the source tags above
  ########################################################################################################################  
  
  sources = ["source.proxmox-iso.proxmox-focal-lb", "source.proxmox-iso.proxmox-rocky-ws", "source.proxmox-iso.proxmox-focal-db"]

  ########################################################################################################################
  # Add provisioners to upload public key to all the VMs
  ########################################################################################################################
  
  provisioner "file" {
    source      = "./${var.KEYNAME}"
    destination = "/home/vagrant/"
  }

  ########################################################################################################################
  # Commands to move the public key copied to the vm via the File Provisioner into the authorized keys
  ########################################################################################################################
  
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    inline = [
      "mkdir -p /home/vagrant/.ssh",
      "touch /home/vagrant/.ssh/authorized_keys",
      "chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys",
      "cat /home/vagrant/${var.KEYNAME} >> /home/vagrant/.ssh/authorized_keys"
    ]
  }

  ########################################################################################################################
  # Add .hcl configuration file to register the systems DNS - base template
  ########################################################################################################################

  provisioner "file" {
    source      = "./system.hcl"
    destination = "/home/vagrant/"
  }

  ########################################################################################################################
  # Add a post_install_iptables-dns-adjustment.sh to the system for consul dns lookup adjustment to the iptables
  ########################################################################################################################

  provisioner "file" {
    source      = "../scripts/proxmox/core-focal/post_install_iptables-dns-adjustment.sh"
    destination = "/home/vagrant/"
    only        = ["proxmox-focal-lb", "proxmox-focal-db"]
  }

  provisioner "file" {
    source      = "../scripts/proxmox/core-rocky/post_install_iptables-dns-adjustment.sh"
    destination = "/home/vagrant/"
    only        = ["proxmox-rocky-ws"]
  }
  ########################################################################################################################
  # Command to move dns-adjustment script so the Consul DNS service will start on boot/reboot
  ########################################################################################################################

  provisioner "shell" {
    inline = [
      "sudo mv /home/vagrant/post_install_iptables-dns-adjustment.sh /etc",
      "sudo chmod u+x /etc/post_install_iptables-dns-adjustment.sh"
    ]
  }

  ########################################################################################################################
  # This is the script that will open the default firewall ports, all ports except 22, 8301, and 8500 are locked down
  # by default.  Edit this script if you want to open additional ports
  ########################################################################################################################

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/core-focal/post_install_prxmx-firewall-configuration.sh"]
    only            = ["proxmox-focal-lb", "proxmox-focal-db"]
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/core-rocky/post_install_prxmx-firewall-configuration.sh"]
    only            = ["proxmox-rocky-ws"]
  }

  ########################################################################################################################
  # Scripts needed to setup internal DNS -- do not edit
  ########################################################################################################################

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/core-focal/post_install_prxmx_ubuntu_2004.sh",
                       "../scripts/proxmox/core-focal/post_install_prxmx_start-cloud-init.sh", 
                       "../scripts/proxmox/focal-ubuntu/post_install_prxmx-ssh-restrict-login.sh", 
                       "../scripts/proxmox/focal-ubuntu/post_install_prxmx_install_hashicorp_consul.sh", 
                       "../scripts/proxmox/focal-ubuntu/post_install_prxmx_update_dns_to_use_systemd_for_consul.sh"]
    only            = ["proxmox-focal-lb", "proxmox-focal-db"]
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/core-rocky/post_install_prxmx_centos_8.sh",
                       "../scripts/proxmox/core-rocky/post_install_prxmx-ssh-restrict-login.sh", 
                       "../scripts/proxmox/core-rocky/post_install_prxmx_install_hashicorp_consul.sh",
                       "../scripts/proxmox/core-rocky/post_install_prxmx_update_dns_to_use_systemd_for_consul.sh"]
    only            = ["proxmox-rocky-ws"]
  }

  ############################################################################################
  # Script to give a dynamic message about the consul DNS upon login
  #
  # https://ownyourbits.com/2017/04/05/customize-your-motd-login-message-in-debian-and-ubuntu/
  #############################################################################################
  
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/core-focal/post_install_update_dynamic_motd_message.sh"]
    only            = ["proxmox-focal-lb", "proxmox-focal-db"]
  }
  
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/core-rocky/post_install_update_dynamic_motd_message.sh"]
    only            = ["proxmox-rocky-ws"]
  }
  
  ############################################################################################
  # Script to install collectd dependencies for collecting hardware metrics
  #
  #############################################################################################
  
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/core-focal/post_install_prxmx_ubuntu_install-collectd.sh"]
    only            = ["proxmox-focal-lb", "proxmox-focal-db"]
  } 

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/core-rocky/post_install_prxmx_install-collectd.sh"]
    only            = ["proxmox-rocky-ws"]
  } 

  ############################################################################################
  # This block is needed due to a bug using Packer and Cloud-Init on Ubuntu 20.04 to remove the
  # temporary SSH port during installation
  #############################################################################################

  provisioner "shell" {
    inline = ["echo 'Resetting SSH port to default!'", "sudo rm /etc/ssh/sshd_config.d/packer-init.conf"]
    only   = ["proxmox-focal-lb", "proxmox-focal-db"]
  }

  ########################################################################################################################
  # These scripts are for customizing the templates where you can install software and configure it via shell script
  ########################################################################################################################
  
  ########################################################################################################################
  # Run the configurations for each element in the network - Focal Load Balancer
  ########################################################################################################################
  
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/focal-lb/nginx-install.sh",
                      "../scripts/proxmox/focal-lb/post_install_prxmx_ubuntu_firewall-additions.sh"]
    only            = ["proxmox-focal-lb"]
  }

  ########################################################################################################################
  # Run the configurations for each element in the network - Rocky Webservers
  ########################################################################################################################
  
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/rocky-ws/nginx-install.sh",
                      "../scripts/proxmox/rocky-ws/post_install_prxmx_rocky_firewall-additions.sh"]
    only            = ["proxmox-rocky-ws"]
  }

  ########################################################################################################################
  # Run the configurations for each element in the network - Focal Database
  ########################################################################################################################

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/focal-db/db-install.sh",
                      "../scripts/proxmox/focal-db/post_install_prxmx_ubuntu_firewall-additions.sh"]
    only            = ["proxmox-focal-db"]
  }

}
