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
      "sudo hostnamectl set-hostname test-${var.yourinitials}-vm${count.index}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials}-vm${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/#datacenter = \"my-dc-1\"/datacenter = \"rice-dc-1\"/' /etc/consul.d/consul.hcl",
      "sudo sed -i 's/10.0.4.67/${var.consulip}/' /etc/consul.d/consul.hcl",
      "sudo systemctl daemon-reload",
      "sudo systemctl start consul.service"     
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