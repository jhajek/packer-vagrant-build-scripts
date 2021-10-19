
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "virtualbox-iso" "ubuntu-vanilla-18043-server-local" {
  boot_command            = ["<esc><wait>", "<esc><wait>", "<enter><wait>", "/install/vmlinuz<wait>", " auto<wait>", " console-setup/ask_detect=false<wait>", " console-setup/layoutcode=us<wait>", " console-setup/modelcode=pc105<wait>", " debconf/frontend=noninteractive<wait>", " debian-installer=en_US<wait>", " fb=false<wait>", " initrd=/install/initrd.gz<wait>", " kbd-chooser/method=us<wait>", " keyboard-configuration/layout=USA<wait>", " keyboard-configuration/variant=USA<wait>", " locale=en_US<wait>", " netcfg/get_domain=vm<wait>", " netcfg/get_hostname=vagrant<wait>", " grub-installer/bootdev=/dev/sda<wait>", " noapic<wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed/preseed-local.cfg<wait>", " -- <wait>", "<enter><wait>"]
  boot_wait               = "10s"
  disk_size               = 20000
  guest_additions_mode    = "disable"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Ubuntu_64"
  http_directory          = "."
  http_port_max           = 9001
  http_port_min           = 9001
  iso_checksum            = "7d8e0055d663bffa27c1718685085626cb59346e7626ba3d3f476322271f573e"
  iso_checksum_type       = "sha256"
  iso_urls                = ["http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.3-server-amd64.iso"]
  shutdown_command        = "echo 'vagrant'|sudo -S shutdown -P now"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_username            = "vagrant"
  ssh_wait_timeout        = "10000s"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "2048"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "ubuntu-vanilla-18043-server-local"
}

build {
  sources = ["source.virtualbox-iso.ubuntu-vanilla-18043-server-local"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    script          = "../scripts/post_install_vagrant.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "../build/{{ .BuildName }}-<no value>-${local.timestamp}.box"
  }
}
