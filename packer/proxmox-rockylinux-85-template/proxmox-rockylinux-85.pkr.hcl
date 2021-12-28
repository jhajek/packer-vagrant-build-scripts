# https://www.packer.io/docs/builders/proxmox/iso
source "proxmox-iso" "proxmox-rockylinux-85" {
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
  vm_name                  = "${var.VMNAME}"
}

build {
  description = "Build base RockyLinux 8.5"

  sources = ["source.proxmox-iso.proxmox-rockylinux-85"]

  ########################################################################################################################
  # File provisioner will SCP your public key to the instance so you can connect over SSH via your 
  # generated RSA private key
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
  # Using the file provisioner to SCP this file to the instance 
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
    source      = "../scripts/proxmox/centos8/post_install_iptables-dns-adjustment.sh"
    destination = "/home/vagrant/"
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
    scripts         = ["../scripts/proxmox/centos8/post_install_prxmx-firewall-configuration.sh"]
  }

  ########################################################################################################################
  # These shell scripts are needed to create the cloud instance and register the instance with Consul DNS
  # Don't edit this
  ########################################################################################################################

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/centos8/post_install_prxmx_centos_8.sh",
                       "../scripts/proxmox/centos8/post_install_prxmx-ssh-restrict-login.sh",
                       "../scripts/proxmox/centos8/post_install_prxmx_install_hashicorp_consul.sh",
                       "../scripts/proxmox/centos8/post_install_prxmx_update_dns_to_use_systemd_for_consul.sh"]
  }

  ########################################################################################################################
  # Script to change the bind_addr in Consul to the dynmaic Go lang call to
  # Interface ens18
  # https://www.consul.io/docs/troubleshoot/common-errors
  ########################################################################################################################
  
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/centos8/post_install_change_consul_bind_interface.sh"]
  }

  ############################################################################################
  # Script to give a dynamic message about the consul DNS upon login
  #
  # https://ownyourbits.com/2017/04/05/customize-your-motd-login-message-in-debian-and-ubuntu/
  #############################################################################################
  
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/centos8/post_install_update_dynamic_motd_message.sh"]
  }  

  ########################################################################################################################
  # Uncomment this block to add your own custom bash install scripts
  # This block you can add your own shell scripts to customize the image you are creating
  ########################################################################################################################

  #  provisioner "shell" {
  #    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
  #    scripts          = ["../path/to/your/shell/script.sh"]
  #  }

}
