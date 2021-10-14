
variable "guest_additions" {
  type    = string
  default = "upload"
}

variable "iso_name" {
  type    = string
  default = "Rocky-8.4-x86_64-minimal.iso"
}

variable "iso_url" {
  type    = string
  default = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.4-x86_64-minimal.iso"
}

variable "kickstart" {
  type    = string
  default = "ks/rocky-linux-8.cfg"
}

# Centos 8 Latest Checksum URl 
# http://bay.uchicago.edu/centos/8-stream/isos/x86_64/CHECKSUM
source "virtualbox-iso" "rocky-linux-8-vanilla" {
  boot_command            = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks/rocky-linux-8.cfg<enter>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>"]
  boot_wait               = "10s"
  disk_size               = 15000
  guest_additions_mode    = "${var.guest_additions}"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "RedHat_64"
  hard_drive_interface    = "sata"
  http_directory          = "."
  http_port_min           = 9001
  http_port_max           = 9100
  iso_checksum            = "0de5f12eba93e00fefc06cdb0aa4389a0972a4212977362ea18bde46a1a1aa4f"
  iso_urls                = ["${var.iso_url}"]
  shutdown_command        = "echo 'vagrant' | sudo -S /sbin/poweroff"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_timeout             = "30m"
  ssh_username            = "vagrant"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "2048"], ["modifyvm", "{{ .Name }}", "--cpus", "2"]]
  virtualbox_version_file = ".vbox_version"
  headless                = "${var.headless_build}"
}

build {
  description = "Build base Rocky Linux 8 x86_64"

  sources = ["source.virtualbox-iso.rocky-linux-8-vanilla"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts          = ["../scripts/post_install_vagrant-rocky-linux-8.sh"]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "../build/{{.BuildName}}-{{.Provider}}-{{timestamp}}.box"
  }
}
