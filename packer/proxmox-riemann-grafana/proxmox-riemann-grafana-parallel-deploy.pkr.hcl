locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }
#################################################################
# Build for Ubuntu Focal 20.04 Riemann A
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################
source "proxmox-iso" "proxmox-riemanna-ubuntu" {
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
  iso_checksum     = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
  iso_urls         = ["http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"]
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
  template_description     = "A Packer template to create a Promox Template - Vanilla Ubuntu"
  vm_name                  = "${var.RIEMANNA}"
}

#################################################################
# Build for CentOS Stream Riemann B
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################
source "proxmox-iso" "proxmox-riemannb-centos-stream" {
  boot_command    = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos-8-stream.ks<enter>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>"]
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
  iso_checksum     = "sha256:79ba22aec5589fc9222d294d4079a0631576f6ba2c081952e81a4e5933126c74"
  iso_urls         = ["http://bay.uchicago.edu/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-20210706-boot.iso"]
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
  vm_name                  = "${var.RIEMANNB}"
}

#################################################################
# Build for Ubuntu Focal 20.04 Riemann MC
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################
source "proxmox-iso" "proxmox-riemannmc-ubuntu" {
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
  iso_checksum     = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
  iso_urls         = ["http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"]
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
  template_description     = "A Packer template to create a Promox Template - Vanilla Ubuntu"
  vm_name                  = "${var.RIEMANNMC}"
}

#################################################################
# Build for Ubuntu Focal 20.04 Graphite A
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################
source "proxmox-iso" "proxmox-graphitea-ubuntu" {
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
  iso_checksum     = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
  iso_urls         = ["http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"]
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
  template_description     = "A Packer template to create a Promox Template - Vanilla Ubuntu"
  vm_name                  = "${var.GRAPHITEA}"
}

#################################################################
# Build for CentOS Stream Graphite B
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################
source "proxmox-iso" "proxmox-graphiteb-centos-stream" {
  boot_command    = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos-8-stream.ks<enter>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>"]
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
  iso_checksum     = "sha256:79ba22aec5589fc9222d294d4079a0631576f6ba2c081952e81a4e5933126c74"
  iso_urls         = ["http://bay.uchicago.edu/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-20210706-boot.iso"]
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
  vm_name                  = "${var.GRAPHITEB}"
}

#################################################################
# Build for Ubuntu Focal 20.04 Graphite MC
# https://www.packer.io/docs/builders/proxmox/iso
#################################################################
source "proxmox-iso" "proxmox-graphitemc-ubuntu" {
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
  iso_checksum     = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
  iso_urls         = ["http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"]
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
  template_description     = "A Packer template to create a Promox Template - Vanilla Ubuntu"
  vm_name                  = "${var.GRAPHITEMC}"
}

build {
  sources = ["source.proxmox-iso.proxmox-riemanna-ubuntu", "source.proxmox-iso.proxmox-riemannb-centos-stream", "source.proxmox-iso.proxmox-riemannmc-ubuntu", "source.proxmox-iso.proxmox-graphitea-ubuntu", "source.proxmox-iso.proxmox-graphiteb-centos-stream", "source.proxmox-iso.proxmox-graphitemc-ubuntu"]

  #Add provisioners to upload public key to all the VMs
  provisioner "file" {
    source      = "./${var.KEYNAME}"
    destination = "/home/vagrant/"
  }
  # Commands to move the public key copied to the vm via the File Provisioner into the authorized keys
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    inline = [
      "mkdir -p /home/vagrant/.ssh",
      "touch /home/vagrant/.ssh/authorized_keys",
      "chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys",
      "cat /home/vagrant/${var.KEYNAME} >> /home/vagrant/.ssh/authorized_keys"
    ]
  }

  #Add .hcl configuration file to register the systems DNS - base template
  provisioner "file" {
    source      = "./system.hcl"
    destination = "/home/vagrant/"
  }

  #Add a post_install_iptables-dns-adjustment.sh to the system for consul dns lookup adjustment to the iptables
  provisioner "file" {
    source      = "../scripts/proxmox/focal-ubuntu/post_install_iptables-dns-adjustment.sh"
    destination = "/home/vagrant/"
    only            = ["proxmox-riemanna-ubuntu", "proxmox-riemannmc-ubuntu", "proxmox-graphitea-ubuntu", "proxmox-graphitemc-ubuntu"]
  }

  ########################################################################################################################
  # Add a post_install_iptables-dns-adjustment.sh to the system for consul dns lookup adjustment to the iptables
  ########################################################################################################################

  provisioner "file" {
    source      = "../scripts/proxmox/centos8/post_install_iptables-dns-adjustment.sh"
    destination = "/home/vagrant/"
    only        = ["proxmox-riemannb-centos-stream", "proxmox-graphiteb-centos-stream"]
  }

  # Command to move dns-adjustment script to a safer place
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
    scripts         = ["../scripts/proxmox/focal-ubuntu/post_install_prxmx-firewall-configuration.sh"]
    only            = ["proxmox-riemanna-ubuntu", "proxmox-riemannmc-ubuntu", "proxmox-graphitea-ubuntu", "proxmox-graphitemc-ubuntu"]
  }

  ########################################################################################################################
  # This is the script that will open the default firewall ports, all ports except 22, 8301, and 8500 are locked down
  # by default.  Edit this script if you want to open additional ports
  ########################################################################################################################

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/centos8/post_install_prxmx-firewall-configuration.sh"]
    only            = ["proxmox-riemannb-centos-stream", "proxmox-graphiteb-centos-stream"]
  }

  ########################################################################################################################
  # Scripts needed to setup internal DNS -- do not edit
  ########################################################################################################################

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/focal-ubuntu/post_install_prxmx_ubuntu_2004.sh", "../scripts/proxmox/focal-ubuntu/post_install_prxmx_start-cloud-init.sh", "../scripts/proxmox/focal-ubuntu/post_install_prxmx-ssh-restrict-login.sh", "../scripts/proxmox/focal-ubuntu/post_install_prxmx_install_hashicorp_consul.sh", "../scripts/proxmox/focal-ubuntu/post_install_prxmx_update_dns_to_use_systemd_for_consul.sh"]
    only            = ["proxmox-riemanna-ubuntu", "proxmox-riemannmc-ubuntu", "proxmox-graphitea-ubuntu", "proxmox-graphitemc-ubuntu"]
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/centos8/post_install_prxmx_centos_8.sh", "../scripts/proxmox/centos8/post_install_prxmx-ssh-restrict-login.sh", "../scripts/proxmox/centos8/post_install_prxmx_install_hashicorp_consul.sh", "../scripts/proxmox/centos8/post_install_prxmx_update_dns_to_use_systemd_for_consul.sh"]
    only            = ["proxmox-riemannb-centos-stream", "proxmox-graphiteb-centos-stream"]
  }

  # Run the configurations for each element in the network - Riemann A

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/riemann-setup/riemann-ubuntu-install.sh", "../scripts/proxmox/riemann-setup/riemanna-ubuntu-setup.sh"]
    only            = ["proxmox-riemanna-ubuntu"]
  }

  # Run the configurations for each element in the network - Riemann B

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/riemann-setup/riemann-centos-stream-install.sh", "../scripts/proxmox/riemann-setup/riemannb-centos-setup.sh"]
    only            = ["proxmox-riemannb-centos-stream"]
  }

  # Run the configurations for each element in the network - Riemann MC

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/riemann-setup/riemann-ubuntu-install.sh", "../scripts/proxmox/riemann-setup/riemannmc-ubuntu-setup.sh"]
    only            = ["proxmox-riemannmc-ubuntu"]
  }

  # Run the configurations for each element in the network - Graphite A

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/graphite-setup/graphitea-ubuntu-install.sh"]
    only            = ["proxmox-graphitea-ubuntu"]
  }

  # Run the configurations for each element in the network - Graphite B

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/graphite-setup/graphiteb-centos-setup.sh"]
    only            = ["proxmox-graphiteb-centos-stream"]
  }

  # Run the configurations for each element in the network - Graphite MC

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts         = ["../scripts/proxmox/graphite-setup/graphitemc-ubuntu-install.sh"]
    only            = ["proxmox-graphitemc-ubuntu"]
  }

  # This block is needed due to a bug using Packer and Cloud-Init on Ubuntu 20.04 to remove the
  # temporary SSH port during installation
  provisioner "shell" {
    inline = ["echo 'Resetting SSH port to default!'", "sudo rm /etc/ssh/sshd_config.d/packer-init.conf"]
    only   = ["proxmox-riemanna-ubuntu", "proxmox-riemannmc-ubuntu", "proxmox-graphitea-ubuntu", "proxmox-graphitemc-ubuntu"]
  }

}
