
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "virtualbox-iso" "centos-vanilla-1810-server-md" {
  boot_command         = ["<up><wait><tab><wait> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks/centos-7-base.cfg<enter><wait>"]
  boot_wait            = "5s"
  communicator         = "ssh"
  disk_size            = 20000
  guest_additions_mode = "disable"
  guest_os_type        = "RedHat_64"
  hard_drive_interface = "sata"
  http_directory       = "."
  http_port_max        = 9001
  http_port_min        = 9001
  iso_checksum         = "9a2c47d97b9975452f7d582264e9fc16d108ed8252ac6816239a3b58cef5c53d"
  iso_checksum_type    = "sha256"
  iso_url              = "https://mirrors.edge.kernel.org/centos/7.7.1908/isos/x86_64/CentOS-7-x86_64-Minimal-1908.iso"
  shutdown_command     = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password         = "vagrant"
  ssh_pty              = "true"
  ssh_username         = "vagrant"
  ssh_wait_timeout     = "30m"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", "2048"], ["createhd", "--filename", "output-virtualbox/packer-virtualbox-disk3.vdi", "--size", "15000", "--format", "VDI", "--variant", "Standard"], ["storageattach", "{{ .Name }}", "--storagectl", "IDE Controller", "--port", "1", "--device", "0", "--type", "hdd", "--medium", "output-virtualbox/packer-virtualbox-disk3.vdi"], ["createhd", "--filename", "output-virtualbox/packer-virtualbox-disk4.vdi", "--size", "15000", "--format", "VDI", "--variant", "Standard"], ["storageattach", "{{ .Name }}", "--storagectl", "IDE Controller", "--port", "1", "--device", "0", "--type", "hdd", "--medium", "output-virtualbox/packer-virtualbox-disk4.vdi"]]
  vm_name              = "centos-vanilla-1810-server-md"
}

build {
  sources = ["source.virtualbox-iso.centos-vanilla-1810-server-md"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    script          = "../scripts/post_install_vagrant-centos-7.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "../build/{{ .BuildName }}-<no value>-${local.timestamp}.box"
  }
}
