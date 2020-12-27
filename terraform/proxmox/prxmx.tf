terraform {
  required_providers {
    proxmox = {
      source  = "registry.example.com/telmate/proxmox"
      version = ">=1.0.0"
    }
  }
  required_version = ">= 0.13"
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://172.16.1.62:8006/api2/json"
    pm_password = "root"
    pm_user = "cluster@pam"
    pm_otp = ""
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/from-1.5/blocks/source
resource "proxmox-qemu-vm" "cloudinit_test" {
  name = var.vmname  
  boot         = "order=virtio0;ide2"
  boot_command = ["<esc><wait>", "<esc><wait>", "<enter><wait>", "/install/vmlinuz<wait>", " auto<wait>", " console-setup/ask_detect=false<wait>", " console-setup/layoutcode=us<wait>", " console-setup/modelcode=pc105<wait>", " debconf/frontend=noninteractive<wait>", " debian-installer=en_US<wait>", " fb=false<wait>", " initrd=/install/initrd.gz ipv6.disable=1<wait>", " kbd-chooser/method=us<wait>", " keyboard-configuration/layout=USA<wait>", " keyboard-configuration/variant=USA<wait>", " locale=en_US<wait>", " netcfg/get_domain=vm<wait>", " grub-installer/bootdev=/dev/vda<wait>", " netcfg/get_hostname=prxmx25<wait>", " noapic<wait>", " preseed/url={{ .HTTPIP }}:{{ .HTTPPort }}/preseed/preseed-prxmx.cfg<wait>", " -- <wait>", "<enter><wait>"]
  boot_wait    = "10s"
  cloud_init   = true
  disks {
    disk_size         = "15G"
    storage_pool      = var.storagepool
    storage_pool_type = var.storagepooltype
    type              = "virtio"
  }
  http_bind_address        = var.ip
  http_directory           = "."
  http_port_max            = 9050
  http_port_min            = 9001
  insecure_skip_tls_verify = true
  iso_checksum             = "sha256:8c5fc24894394035402f66f3824beb7234b757dd2b5531379cb310cedfdf0996"
  iso_file                 = "local:iso/ubuntu-18.04.5-server-amd64.iso"
  iso_storage_pool         = "local"
  memory                   = 2048
  network_adapters {
    bridge   = "vmbr0"
    firewall = false
    model    = "virtio"
  }
  node             = var.node
  os               = "l26"
  password         = var.password
  proxmox_url      = var.prxmx-url
  qemu_agent       = true
  scsi_controller  = "virtio-scsi-pci"
  ssh_password     = "vagrant"
  ssh_port         = 22
  ssh_username     = "vagrant"
  ssh_wait_timeout = "10000s"
  template_name    = "Ubuntu18045"
  unmount_iso      = true
  username         = var.uname
  vm_name          = var.vmname
}

