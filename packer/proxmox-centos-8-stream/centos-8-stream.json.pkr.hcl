# https://www.packer.io/docs/builders/proxmox/iso
source "proxmox-iso" "centos-stream" {
  boot_command            = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos-8-stream.ks<enter>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>"]
  boot_wait    = "5s"
  cores        = "${var.NUMBEROFCORES}"
  node         = "${var.NODENAME}"
  username     = "${var.USERNAME}"
  token        = "${var.PROXMOX_TOKEN}"
  cpu_type     = "host"
  scsi_controller = "virtio-scsi-single"
  disks {
    disk_size         = "${var.DISKSIZE}"
    storage_pool      = "${var.STORAGEPOOL}"
    storage_pool_type = "lvm"
    type              = "virtio"
  }
  http_directory   = "./"
  http_port_max    = 9200
  http_port_min    = 9001
  iso_checksum            = "sha256:79ba22aec5589fc9222d294d4079a0631576f6ba2c081952e81a4e5933126c74"
  iso_urls                = ["http://bay.uchicago.edu/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-20210706-boot.iso"]
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
  ssh_port             = 22
  ssh_timeout          = "20m"
  ssh_wait_timeout     = "1800s"
  vm_name              = "${var.VMNAME}"
}

build {
  description = "Build base CentOS 8 x86_64"

  sources = ["source.proxmox-iso.centos-stream"]

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

    provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts          = ["../scripts/proxmox/post_install_prxmx_centos_8.sh"]
  }

}
