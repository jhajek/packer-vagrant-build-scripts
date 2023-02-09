locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# Centos 9 Latest Checksum URl 
# http://download.rockylinux.org/pub/rocky/9/isos/x86_64/
source "virtualbox-iso" "rocky-linux-8-vanilla" {
  boot_command            = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks/rocky-linux-8.cfg<enter>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>", "<wait10><wait10><wait10>"]
  boot_wait               = "10s"
  disk_size               = 15000
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "RedHat_64"
  hard_drive_interface    = "sata"
  http_directory          = "."
  http_port_min           = 9001
  http_port_max           = 9100
  iso_checksum            = "sha256:a36753d0efbea2f54a3dc7bfaa4dba95efe9aa3d6af331d5c5b147ea91240c21"
  iso_urls                = ["http://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.1-x86_64-boot.iso"]
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
  description = "Build base Rocky Linux 8 x86_64"

  sources = ["source.virtualbox-iso.rocky-linux-8-vanilla"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    scripts          = ["../scripts/post_install_vagrant-rockylinux-85.sh"]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    #compression_level = 9
    output              = "${var.build_artifact_location}{{ .BuildName }}-${local.timestamp}.box"
  }
}
