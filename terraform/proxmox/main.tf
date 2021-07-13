resource "random_id" "id" {
  byte_length = 8
}

resource "proxmox_vm_qemu" "test" {
  count       = var.numberofvms
  name        = "test-${var.yourinitials}-vm${count.index}"
  desc        = var.desc
  target_node = var.target_node
  clone       = var.template_to_clone
  os_type     = "cloud-init"
  memory      = var.memory
  cores       = var.cores
  sockets     = var.sockets
  bootdisk    = "scsi0"
  boot        = "cdn"
  agent       = 1
  additional_wait = var.additional_wait
  clone_wait = var.clone_wait

  ipconfig0 = "ip=dhcp"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  disk {
    type    = "scsi"
    storage = var.storage
    size    = var.disk_size
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname test-${var.yourinitials}-vm${count.index}"
    ]

    connection {
      type        = "ssh"
      user        = "vagrant"
      private_key = file("${path.module}/${var.keypath}")
      host        = self.ssh_host
      port        = self.ssh_port
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/consul/latest/docs/resources/service
# How to add the consul_service to the terraform provider
resource "consul_service" "proxmox" {
  node    = "${consul_node.compute[count.index]}"
  
  connection {
  type        = "ssh"
  user        = "vagrant"
  private_key = file("${path.module}/${var.keypath}")
  host        = self.ssh_host
  port        = self.ssh_port
  }
}

resource "consul_node" "compute" {
  count   = var.numberofvms
  name    = "${var.yourinitials}-vm${count.index}"
  address = ""
  
  connection {
  type        = "ssh"
  user        = "vagrant"
  private_key = file("${path.module}/${var.keypath}")
  host        = self.ssh_host
  port        = self.ssh_port
  }
}