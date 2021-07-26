resource "random_id" "id" {
  byte_length = 8
}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle#example-usage
resource "random_shuffle" "datadisk" {
  input = ["datadisk1", "datadisk2", "datadisk3", "datadisk4", "datadisk5"]
  result_count = 1 
}

# Create Riemann A

resource "proxmox_vm_qemu" "riemanna" {
  count       = var.numberofvms
  name        = "${var.yourinitials_a}"
  desc        = var.desc_a
  target_node = var.target_node
  clone       = var.template_to_clone
  os_type     = "cloud-init"
  memory      = var.memory
  cores       = var.cores
  sockets     = var.sockets
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "virtio0"
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
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

  provisioner "remote-exec" {
    # With the clone there is a duplicate consul node-id - going to try to delete the node-id so that a new one is generated when Terraform deploys these instances
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/#datacenter = \"my-dc-1\"/datacenter = \"rice-dc-1\"/' /etc/consul.d/consul.hcl",
      "echo 'retry_join = [\"${var.consulip}\"]' | sudo tee -a /etc/consul.d/consul.hcl", 
      "sudo systemctl daemon-reload",
      "sudo systemctl restart consul.service",
      "sudo cat /opt/consul/node-id",
      "sudo rm /opt/consul/node-id",
      "sudo systemctl restart consul"
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

# Create Riemann B

resource "proxmox_vm_qemu" "riemannb" {
  count       = var.numberofvms
  name        = "${var.yourinitials_b}"
  desc        = var.desc_b
  target_node = var.target_node
  clone       = var.template_to_clone
  os_type     = "cloud-init"
  memory      = var.memory
  cores       = var.cores
  sockets     = var.sockets
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "virtio0"
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
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

  provisioner "remote-exec" {
    # With the clone there is a duplicate consul node-id - going to try to delete the node-id so that a new one is generated when Terraform deploys these instances
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/#datacenter = \"my-dc-1\"/datacenter = \"rice-dc-1\"/' /etc/consul.d/consul.hcl",
      "echo 'retry_join = [\"${var.consulip}\"]' | sudo tee -a /etc/consul.d/consul.hcl", 
      "sudo systemctl daemon-reload",
      "sudo systemctl restart consul.service",
      "sudo cat /opt/consul/node-id",
      "sudo rm /opt/consul/node-id",
      "sudo systemctl restart consul"
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

# Create Riemann MC

resource "proxmox_vm_qemu" "riemannmc" {
  count       = var.numberofvms
  name        = "${var.yourinitials_mc}"
  desc        = var.desc_mc
  target_node = var.target_node
  clone       = var.template_to_clone
  os_type     = "cloud-init"
  memory      = var.memory
  cores       = var.cores
  sockets     = var.sockets
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "virtio0"
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
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

  provisioner "remote-exec" {
    # With the clone there is a duplicate consul node-id - going to try to delete the node-id so that a new one is generated when Terraform deploys these instances
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/#datacenter = \"my-dc-1\"/datacenter = \"rice-dc-1\"/' /etc/consul.d/consul.hcl",
      "echo 'retry_join = [\"${var.consulip}\"]' | sudo tee -a /etc/consul.d/consul.hcl", 
      "sudo systemctl daemon-reload",
      "sudo systemctl restart consul.service",
      "sudo cat /opt/consul/node-id",
      "sudo rm /opt/consul/node-id",
      "sudo systemctl restart consul"
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
