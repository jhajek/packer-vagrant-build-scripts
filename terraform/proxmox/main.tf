resource "proxmox_vm_qemu" "test" {
  count       = 3
  name        = "test-vm${count.index}"
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
      "sudo hostnamectl set-hostname test-vm${count.index}"
    ]

    connection {
      type        = "ssh"
      user        = "vagrant"
      private_key = file("${path.module}/id_rsa_jrh_sample")
      host        = self.ssh_host
      port        = self.ssh_port
    }
  }
}