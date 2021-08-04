locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/from-1.5/blocks/source
source "proxmox-iso" "ubuntu20042-vanilla-live-server" {
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
  iso_checksum            = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
  iso_urls                = ["http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"]
  iso_storage_pool = "local"
  memory           = "${var.MEMORY}"
  network_adapters {
    bridge   = "vmbr0"
    model    = "virtio"
  }
  os                   = "l26"
  proxmox_url          = "${var.URL}"
  insecure_skip_tls_verify = true
  unmount_iso          = true
  qemu_agent           = true
  cloud_init           = true
  cloud_init_storage_pool = "local"
  ssh_password         = "vagrant"
  ssh_username         = "vagrant"
  ssh_port             = 2222
  ssh_timeout          = "20m"
  ssh_wait_timeout     = "1800s"
  template_description = "A Packer template to create a Promox Template - Vanilla Ubuntu"
  vm_name              = "${var.VMNAME}"
}

build {
  sources = ["source.proxmox-iso.ubuntu20042-vanilla-live-server"]

#Add provisioners to upload public key to all the VMs
  provisioner "file" {
    source = "./${var.KEYNAME}"
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
    source = "./system.hcl"
    destination = "/home/vagrant/"
  }

#Add a post_install_iptables-dns-adjustment.sh to the system for consul dns lookup adjustment to the iptables
  provisioner "file" {
    source = "../scripts/proxmox/focal-ubuntu/post_install_iptables-dns-adjustment.sh"
    destination = "/home/vagrant/"
  }

# Command to move dns-adjustment script to a safer place
  provisioner "shell" {
    inline = [
      "sudo mv /home/vagrant/post_install_iptables-dns-adjustment.sh /etc",
      "sudo chmod u+x /etc/post_install_iptables-dns-adjustment.sh"
    ]
  }
# Scripts needed to setup internal DNS -- do not edit
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts          = ["../scripts/proxmox/focal-ubuntu/post_install_prxmx_ubuntu_2004.sh","../scripts/proxmox/focal-ubuntu/post_install_prxmx_start-cloud-init.sh","../scripts/proxmox/focal-ubuntu/post_install_prxmx-ssh-restrict-login.sh","../scripts/proxmox/focal-ubuntu/post_install_prxmx_install_hashicorp_consul.sh","../scripts/proxmox/focal-ubuntu/post_install_prxmx_update_dns_to_use_systemd_for_consul.sh","../scripts/proxmox/riemann-setup/riemann-ubuntu-install.sh"]
  }

# This block you can add your own shell scripts to customize the image you are creating

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts          = ["../scripts/proxmox/riemann-setup/riemann-ubuntu-install.sh"]
  }


    provisioner "shell" {
    #inline_shebang  =  "#!/usr/bin/bash -e"
    inline          = ["echo 'Resetting SSH port to default!'", "sudo rm /etc/ssh/sshd_config.d/packer-init.conf"]
    }
}
