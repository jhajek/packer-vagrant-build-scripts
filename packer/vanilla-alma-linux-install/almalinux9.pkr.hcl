locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "virtualbox-iso" "alma-linux-9-vanilla" {
  boot_command            = ["<tab> text ks.inst=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks/almalinux9.cfg<enter>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>"]
  boot_wait               = "10s"
  disk_size               = 15000
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "RedHat_64"
  hard_drive_interface    = "sata"
  http_directory          = "."
  http_port_min           = 9001
  http_port_max           = 9100
  iso_checksum            = "sha256:9f22bd98c8930b1d0b2198ddd273c6647c09298e10a0167197a3f8c293d03090"
  iso_urls                = ["http://almalinux.interhost.co.il/9.1/isos/x86_64/AlmaLinux-9.1-x86_64-boot.iso"]
  shutdown_command        = "echo 'vagrant' | sudo -S /sbin/poweroff"
  ssh_password            = "${var.SSHPW}"
  ssh_port                = 22
  ssh_timeout             = "30m"
  ssh_username            = "vagrant"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "4096"], ["modifyvm", "{{ .Name }}", "--cpus", "1"]]
  virtualbox_version_file = ".vbox_version"
  headless                = "${var.headless_build}"
}

build {
  description = "Build base Alma Linux 9 x86_64"

  sources = ["source.virtualbox-iso.alma-linux-9-vanilla"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts          = ["../scripts/post_install_vagrant-almalinux-9.sh"]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    #compression_level = 9
    output              = "${var.build_artifact_location}{{ .BuildName }}-${local.timestamp}.box"
  }
}
