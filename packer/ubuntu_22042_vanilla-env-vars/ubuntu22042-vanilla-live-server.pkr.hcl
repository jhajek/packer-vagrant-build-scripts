###############################################################################################################
# Packer Virtualbox-iso documentation: https://developer.hashicorp.com/packer/plugins/builders/virtualbox/iso
###############################################################################################################
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

packer {
  required_plugins {
    virtualbox = {
      version = ">= 1.0.4"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "ubuntu-22041-server" {
    boot_command = [
        "e<wait>",
        "<down><down><down>",
        "<end><bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
      ]
  boot_wait               = "5s"
  disk_size               = 15000
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Ubuntu_64"
  http_directory          = "subiquity/http"
  http_port_max           = 9200
  http_port_min           = 9001
  iso_checksum            = "sha256:10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
  iso_urls                = ["https://mirrors.edge.kernel.org/ubuntu-releases/22.04.1/ubuntu-22.04.1-live-server-amd64.iso"]
  shutdown_command        = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_username            = "vagrant"
  ssh_password            = "${local.user-ssh-password}"
  ssh_timeout             = "45m"
  cpus                    = 2
  memory                  = "${var.memory_amount}"
  # Change to --nat-localhostreachable1 forced by https://github.com/hashicorp/packer/issues/12118
  vboxmanage              = [["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "jammy-server"
  headless                = "${var.headless_build}"
}

build {
  sources = ["source.virtualbox-iso.ubuntu-22041-server"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -E -S sh '{{ .Path }}'"
    script          = "../scripts/post_install_ubuntu_2204_vagrant.sh"
  }

  provisioner "shell" {
    inline = ["echo $DBUSER", "echo $DBUSER > /home/vagrant/TEST"]
    environment_vars = ["DBUSER=${local.db_user}"]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    output              = "${var.build_artifact_location}{{ .BuildName }}-${local.timestamp}.box"
  }
}
