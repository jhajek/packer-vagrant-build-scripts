
variable "guest_additions" {
  type    = string
  default = "disable"
}

variable "iso_name" {
  type    = string
  default = "CentOS-Stream-8-x86_64-latest-boot.iso"
}

variable "iso_url" {
  type    = string
  default = "http://bay.uchicago.edu/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-latest-boot.iso"
}

variable "kickstart" {
  type    = string
  default = "ks/centos-8-stream.cfg"
}

variable "proxy" {
  type    = string
  default = "${env("http_proxy")}"
}

source "virtualbox-iso" "centos-8-stream-vanilla" {
  boot_command            = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks/centos-8-stream.cfg<enter>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>"]
  boot_wait               = "10s"
  disk_size               = 15000
  guest_additions_mode    = "${var.guest_additions}"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "RedHat_64"
  hard_drive_interface    = "sata"
  headless                = false
  http_directory          = "."
  http_port_min           = 9001
  http_port_max           = 9100
  iso_checksum            = "sha256:ecc199ad524f0451aae07bd873d65c86b4d4e1ad2f20bc28ad2ca3eaf3ce0009"
  iso_urls                = ["${var.iso_url}"]
  shutdown_command        = "echo 'vagrant'| sudo -S /sbin/poweroff"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_timeout             = "30m"
  ssh_username            = "vagrant"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "2048"], ["modifyvm", "{{ .Name }}", "--cpus", "2"]]
  virtualbox_version_file = ".vbox_version"
}

build {
  description = "Build base CentOS 8 x86_64"

  sources = ["source.virtualbox-iso.centos-8-stream-vanilla"]

  provisioner "shell" {
    environment_vars = ["http_proxy=${var.proxy}", "guest_additions_mode=${var.guest_additions}"]
    scripts          = ["../scripts/post_install_vagrant-centos-8.sh"]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "../build/{{.BuildName}}-{{.Provider}}-{{timestamp}}.box"
  }
}
