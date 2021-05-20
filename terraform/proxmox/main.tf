resource "proxmox_vm_qemu" "test" {
  count       = var.numberofvms
  name        = "test-jrh-vm${count.index}"
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
      "sudo hostnamectl set-hostname test-jrh-vm${count.index}"
    ]

    connection {
      type        = "ssh"
      user        = "vagrant"
      private_key = file("${path.module}/"var.keypath)
      host        = self.ssh_host
      port        = self.ssh_port
    }
  }
}