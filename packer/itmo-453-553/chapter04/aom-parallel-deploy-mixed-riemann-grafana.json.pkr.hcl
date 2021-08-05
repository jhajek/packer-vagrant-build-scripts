locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "virtualbox-iso" "centos-graphiteb" {
  boot_command         = ["<up><wait><tab><wait> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks/centos-7-base.cfg<enter><wait>"]
  boot_wait            = "5s"
  communicator         = "ssh"
  disk_size            = 20000
  guest_additions_mode = "disable"
  guest_os_type        = "RedHat_64"
  hard_drive_interface = "sata"
  headless             = "true"
  http_directory       = "."
  http_port_max        = 9050
  http_port_min        = 9001
  iso_checksum         = "sha256:659691c28a0e672558b003d223f83938f254b39875ee7559d1a4a14c79173193"
  iso_url              = "https://mirrors.edge.kernel.org/centos/7.8.2003/isos/x86_64/CentOS-7-x86_64-Minimal-2003.iso"
  shutdown_command     = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password         = "vagrant"
  ssh_pty              = "true"
  ssh_username         = "vagrant"
  ssh_wait_timeout     = "60m"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", "${var.mem-build-allocation}"]]
  vm_name              = "centos-graphiteb"
}

source "virtualbox-iso" "centos-riemannb" {
  boot_command         = ["<up><wait><tab><wait> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks/centos-7-base.cfg<enter><wait>"]
  boot_wait            = "5s"
  communicator         = "ssh"
  disk_size            = 20000
  guest_additions_mode = "disable"
  guest_os_type        = "RedHat_64"
  hard_drive_interface = "sata"
  headless             = "${var.headless-val}"
  http_directory       = "."
  http_port_max        = 9050
  http_port_min        = 9001
  iso_checksum         = "sha256:659691c28a0e672558b003d223f83938f254b39875ee7559d1a4a14c79173193"
  iso_url              = "https://mirrors.edge.kernel.org/centos/7.8.2003/isos/x86_64/CentOS-7-x86_64-Minimal-2003.iso"
  shutdown_command     = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password         = "vagrant"
  ssh_pty              = "true"
  ssh_username         = "vagrant"
  ssh_wait_timeout     = "60m"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", "${var.mem-build-allocation}"]]
  vm_name              = "centos-riemannb"
}

source "virtualbox-iso" "ub-graphitea" {
  boot_command         = ["<esc><wait>", "<esc><wait>", "<enter><wait>", "/install/vmlinuz<wait>", " auto<wait>", " console-setup/ask_detect=false<wait>", " console-setup/layoutcode=us<wait>", " console-setup/modelcode=pc105<wait>", " debconf/frontend=noninteractive<wait>", " debian-installer=en_US<wait>", " fb=false<wait>", " initrd=/install/initrd.gz<wait>", " kbd-chooser/method=us<wait>", " keyboard-configuration/layout=USA<wait>", " keyboard-configuration/variant=USA<wait>", " locale=en_US<wait>", " netcfg/get_domain=vm<wait>", " netcfg/get_hostname=uvanilla<wait>", " grub-installer/bootdev=/dev/sda<wait>", " noapic<wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed/preseed.cfg<wait>", " -- <wait>", "<enter><wait>"]
  boot_wait            = "5s"
  communicator         = "ssh"
  disk_size            = 20000
  guest_additions_mode = "disable"
  guest_os_type        = "Ubuntu_64"
  hard_drive_interface = "sata"
  headless             = "${var.headless-val}"
  http_directory       = "."
  http_port_max        = 9050
  http_port_min        = 9001
  iso_checksum         = "sha256:8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
  iso_urls             = "http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.5-server-amd64.iso"
  shutdown_command     = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password         = "vagrant"
  ssh_pty              = "true"
  ssh_username         = "vagrant"
  ssh_wait_timeout     = "60m"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", "${var.mem-build-allocation}"]]
  vm_name              = "ub-graphitea"
}

source "virtualbox-iso" "ub-graphitemc" {
  boot_command         = ["<esc><wait>", "<esc><wait>", "<enter><wait>", "/install/vmlinuz<wait>", " auto<wait>", " console-setup/ask_detect=false<wait>", " console-setup/layoutcode=us<wait>", " console-setup/modelcode=pc105<wait>", " debconf/frontend=noninteractive<wait>", " debian-installer=en_US<wait>", " fb=false<wait>", " initrd=/install/initrd.gz<wait>", " kbd-chooser/method=us<wait>", " keyboard-configuration/layout=USA<wait>", " keyboard-configuration/variant=USA<wait>", " locale=en_US<wait>", " netcfg/get_domain=vm<wait>", " netcfg/get_hostname=uvanilla<wait>", " grub-installer/bootdev=/dev/sda<wait>", " noapic<wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed/preseed.cfg<wait>", " -- <wait>", "<enter><wait>"]
  boot_wait            = "5s"
  communicator         = "ssh"
  disk_size            = 20000
  guest_additions_mode = "disable"
  guest_os_type        = "Ubuntu_64"
  hard_drive_interface = "sata"
  headless             = "${var.headless-val}"
  http_directory       = "."
  http_port_max        = 9050
  http_port_min        = 9001
  iso_checksum         = "sha256:8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
  iso_urls             = "http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.5-server-amd64.iso"
  shutdown_command     = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password         = "vagrant"
  ssh_pty              = "true"
  ssh_username         = "vagrant"
  ssh_wait_timeout     = "60m"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", "${var.mem-build-allocation}"]]
  vm_name              = "ub-graphitemc"
}

source "virtualbox-iso" "ub-riemanna" {
  boot_command         = ["<esc><wait>", "<esc><wait>", "<enter><wait>", "/install/vmlinuz<wait>", " auto<wait>", " console-setup/ask_detect=false<wait>", " console-setup/layoutcode=us<wait>", " console-setup/modelcode=pc105<wait>", " debconf/frontend=noninteractive<wait>", " debian-installer=en_US<wait>", " fb=false<wait>", " initrd=/install/initrd.gz<wait>", " kbd-chooser/method=us<wait>", " keyboard-configuration/layout=USA<wait>", " keyboard-configuration/variant=USA<wait>", " locale=en_US<wait>", " netcfg/get_domain=vm<wait>", " netcfg/get_hostname=uvanilla<wait>", " grub-installer/bootdev=/dev/sda<wait>", " noapic<wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed/preseed.cfg<wait>", " -- <wait>", "<enter><wait>"]
  boot_wait            = "5s"
  communicator         = "ssh"
  disk_size            = 20000
  guest_additions_mode = "disable"
  guest_os_type        = "Ubuntu_64"
  hard_drive_interface = "sata"
  headless             = "${var.headless-val}"
  http_directory       = "."
  http_port_max        = 9050
  http_port_min        = 9001
  iso_checksum         = "sha256:8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
  iso_urls             = "http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.5-server-amd64.iso"
  shutdown_command     = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password         = "vagrant"
  ssh_pty              = "true"
  ssh_username         = "vagrant"
  ssh_wait_timeout     = "60m"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", "${var.mem-build-allocation}"]]
  vm_name              = "ub-riemanna"
}

source "virtualbox-iso" "ub-riemannmc" {
  boot_command         = ["<esc><wait>", "<esc><wait>", "<enter><wait>", "/install/vmlinuz<wait>", " auto<wait>", " console-setup/ask_detect=false<wait>", " console-setup/layoutcode=us<wait>", " console-setup/modelcode=pc105<wait>", " debconf/frontend=noninteractive<wait>", " debian-installer=en_US<wait>", " fb=false<wait>", " initrd=/install/initrd.gz<wait>", " kbd-chooser/method=us<wait>", " keyboard-configuration/layout=USA<wait>", " keyboard-configuration/variant=USA<wait>", " locale=en_US<wait>", " netcfg/get_domain=vm<wait>", " netcfg/get_hostname=uvanilla<wait>", " grub-installer/bootdev=/dev/sda<wait>", " noapic<wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed/preseed.cfg<wait>", " -- <wait>", "<enter><wait>"]
  boot_wait            = "5s"
  communicator         = "ssh"
  disk_size            = 20000
  guest_additions_mode = "disable"
  guest_os_type        = "Ubuntu_64"
  hard_drive_interface = "sata"
  headless             = "${var.headless-val}"
  http_directory       = "."
  http_port_max        = 9050
  http_port_min        = 9001
  iso_checksum         = "sha256:8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
  iso_urls             = "http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.5-server-amd64.iso"
  shutdown_command     = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password         = "vagrant"
  ssh_pty              = "true"
  ssh_username         = "vagrant"
  ssh_wait_timeout     = "60m"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", "${var.mem-build-allocation}"]]
  vm_name              = "ub-riemannmc"
}

build {
  sources = ["source.virtualbox-iso.centos-graphiteb", "source.virtualbox-iso.centos-riemannb", "source.virtualbox-iso.ub-graphitea", "source.virtualbox-iso.ub-graphitemc", "source.virtualbox-iso.ub-riemanna", "source.virtualbox-iso.ub-riemannmc"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    only            = ["ub-riemanna"]
    script          = "../../scripts/itmo-453-553/chapter-04/post_install_itmo-453-553-vagrant-ub-riemanna-setup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    only            = ["centos-riemannb"]
    script          = "../../scripts/itmo-453-553/chapter-04/post_install_itmo-453-553-vagrant-centos-riemannb-setup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    only            = ["ub-riemannmc"]
    script          = "../../scripts/itmo-453-553/chapter-04/post_install_itmo-453-553-vagrant-ub-riemannmc-setup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    only            = ["ub-graphitea"]
    script          = "../../scripts/itmo-453-553/chapter-04/post_install_itmo-453-553-vagrant-ub-graphitea-setup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    only            = ["centos-graphiteb"]
    script          = "../../scripts/itmo-453-553/chapter-04/post_install_itmo-453-553-vagrant-centos-graphiteb-setup.sh"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    only            = ["ub-graphitemc"]
    script          = "../../scripts/itmo-453-553/chapter-04/post_install_itmo-453-553-vagrant-ub-graphitemc-setup.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "../build/{{ .BuildName }}-<no value>-${local.timestamp}.box"
  }
}
