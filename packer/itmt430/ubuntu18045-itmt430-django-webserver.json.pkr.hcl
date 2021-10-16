
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "virtualbox-iso" "ubuntu-ws-18044-server" {
  boot_command            = ["<esc><wait>", "<esc><wait>", "<enter><wait>", "/install/vmlinuz<wait>", " auto<wait>", " console-setup/ask_detect=false<wait>", " console-setup/layoutcode=us<wait>", " console-setup/modelcode=pc105<wait>", " debconf/frontend=noninteractive<wait>", " debian-installer=en_US<wait>", " fb=false<wait>", " initrd=/install/initrd.gz<wait>", " kbd-chooser/method=us<wait>", " keyboard-configuration/layout=USA<wait>", " keyboard-configuration/variant=USA<wait>", " locale=en_US<wait>", " netcfg/get_domain=vm<wait>", " netcfg/get_hostname=vagrant<wait>", " grub-installer/bootdev=/dev/sda<wait>", " noapic<wait>", " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed/preseed.cfg<wait>", " -- <wait>", "<enter><wait>"]
  boot_wait               = "10s"
  disk_size               = 20000
  guest_additions_mode    = "disable"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Ubuntu_64"
  http_directory          = "."
  http_port_max           = 9001
  http_port_min           = 9001
  iso_checksum            = "sha256:8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
  iso_urls                = "http://cdimage.ubuntu.com/ubuntu/releases/bionic/release/ubuntu-18.04.5-server-amd64.iso"
  shutdown_command        = "echo 'vagrant'|sudo -S shutdown -P now"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_username            = "vagrant"
  ssh_wait_timeout        = "10000s"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "2048"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "ubuntu-ws-18044-server"
}

build {
  sources = ["source.virtualbox-iso.ubuntu-ws-18044-server"]

  provisioner "file" {
    destination = "/home/vagrant/"
    source      = "./id_rsa_github_deploy_key"
  }

  provisioner "file" {
    destination = "/home/vagrant/"
    source      = "./config"
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    inline          = ["mkdir -p /home/vagrant/.ssh", "mkdir -p /root/.ssh", "chmod 600 /home/vagrant/id_rsa_github_deploy_key", "cp -v /home/vagrant/id_rsa_github_deploy_key /home/vagrant/.ssh/", "cp -v /home/vagrant/config /home/vagrant/.ssh/", "cp -v /home/vagrant/config /root/.ssh/", "git clone git@github.com:illinoistech-itm/hajek.git"]
  }

  provisioner "shell" {
    environment_vars = ["DBPASS=${var.database-root-password}", "USERPASS=${var.database-user-password}", "ACCESSFROMIP=${var.database-access-from-ip}", "DATABASEIP=${var.database-ip}", "WEBSERVERIP=${var.webserver-ip}", "DATABASENAME=${var.database-name}", "DATABASEUSERNAME=${var.database-user-name}"]
    execute_command  = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    script           = "../scripts/post_install_itmt430-github-js-app.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "../build/{{ .BuildName }}-<no value>-${local.timestamp}.box"
  }
}
