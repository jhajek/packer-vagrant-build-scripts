# This file was autogenerated by the BETA 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# All generated input variables will be of 'string' type as this is how Packer JSON
# views them; you can change their type later on. Read the variables type
# constraints documentation
# https://www.packer.io/docs/from-1.5/variables#type-constraints for more info.
# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/from-1.5/blocks/source
source "proxmox-iso" "ubuntu-vanilla" {
  boot_command = ["<esc><wait>", "<esc><wait>", "<enter><wait>", "/install/vmlinuz<wait>", " auto<wait>", " console-setup/ask_detect=false<wait>", " console-setup/layoutcode=us<wait>", " console-setup/modelcode=pc105<wait>", " debconf/frontend=noninteractive<wait>", " debian-installer=en_US<wait>", " fb=false<wait>", " initrd=/install/initrd.gz<wait>", " kbd-chooser/method=us<wait>", " keyboard-configuration/layout=USA<wait>", " keyboard-configuration/variant=USA<wait>", " locale=en_US<wait>", " netcfg/get_domain=vm<wait>", " netcfg/get_hostname=uvanilla<wait>", " grub-installer/bootdev=/dev/sda<wait>", " noapic<wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed/preseed-prxmx.cfg<wait>", " -- <wait>", "<enter><wait>"]
  boot_wait    = "10s"
  cores        = "${var.NUMBEROFCORES}"
  node         = "${var.NODENAME}"
  username     = "${var.USERNAME}"
  token        = "${var.PROXMOX_TOKEN}"
  cpu_type     = "host"
  disks {
    disk_size         = "${var.DISKSIZE}"
    storage_pool      = "${var.STORAGEPOOL}"
    storage_pool_type = "lvm"
    type              = "scsi"
  }
  http_directory   = "."
  http_port_max    = 9200
  http_port_min    = 9001
  iso_checksum     = "sha256:8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
  iso_file         = "local:iso/ubuntu-18.04.5-server-amd64.iso"
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
  ssh_wait_timeout     = "10000s"
  template_description = "A Packer template to create a Promox Template - Vanilla Ubuntu"
  vm_name              = "${var.VMNAME}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/from-1.5/blocks/build
build {
  sources = ["source.proxmox-iso.ubuntu-vanilla"]

#Add provisioners to upload public key to all the VMs
  provisioner "file" {
    source = "../${var.KEYNAME}"
    destination = "/home/vagrant/"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    inline = [
      "mkdir -p /home/vagrant/.ssh",
      "touch /home/vagrant/.ssh/authorized_keys",
      "chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys",
      "cat /home/vagrant/${var.KEYNAME} >> /home/vagrant/.ssh/authorized_keys"
        ]
  }

  # could not parse template for following block: "template: hcl2_upgrade:2:41: executing \"hcl2_upgrade\" at <.Vars>: can't evaluate field Vars in type struct { HTTPIP string; HTTPPort string }"
  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts          = ["../scripts/post_install_prxmx.sh","../scripts/post_install_prxmx_start-cloud-init.sh","../scripts/post_install_prxmx-ssh-restrict-login.sh"]
  }

}
