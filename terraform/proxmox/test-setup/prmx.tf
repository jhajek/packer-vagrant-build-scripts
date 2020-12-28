terraform {
  required_providers {
    proxmox = {
    source = "registry.terraform.io/ondrejsika/proxmox"
    }
  }
}
provider "proxmox" {
    pm_api_url = "https://172.16.1.62:8006/api2/json"
    pm_user = "root@pam"
    pm_password = "cluster"
    pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "resource-name" {
    name = "ubuntu-class-server"
    target_node = "pve"
    iso = "local:iso/ubuntu-18.04.5-server-amd64.iso"
    network {
      bridge   = "vmbr0"
      firewall = false
      model    = "virtio"
    }
}