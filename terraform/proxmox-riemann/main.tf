###############################################################################################
# This template demonstrates a Terraform plan to deploy three virtual machines, two 
# two Ubuntu Focal 20.04 instances and one CentOS Stream instance and installs Riemann software 
# on each instance.
# Run this by typing: terraform apply -parallelism=1
###############################################################################################
resource "random_id" "id" {
  byte_length = 8
}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle#example-usage
resource "random_shuffle" "datadisk" {
  input = ["datadisk2","datadisk3"]
  result_count = 1 
}

# Create Riemann A

resource "proxmox_vm_qemu" "riemanna" {
  count       = var.numberofvms
  name        = "${var.yourinitials_a}"
  desc        = var.desc_a
  target_node = var.target_node
  clone       = var.template_to_clone_a
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
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

  provisioner "remote-exec" {
    # This inline provisioner is needed to accomplish the final fit and finish of your deployed
    # instance and condigure the system to register the FQDN with the Consul DNS system
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials_a}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials_a}/' /etc/consul.d/system.hcl",
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
  clone       = var.template_to_clone_b
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
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

  provisioner "remote-exec" {
    # This inline provisioner is needed to accomplish the final fit and finish of your deployed
    # instance and condigure the system to register the FQDN with the Consul DNS system
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials_b}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials_b}/' /etc/consul.d/system.hcl",
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
  clone       = var.template_to_clone_mc
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
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

  provisioner "remote-exec" {
    # This inline provisioner is needed to accomplish the final fit and finish of your deployed
    # instance and condigure the system to register the FQDN with the Consul DNS system
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials_mc}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials_mc}/' /etc/consul.d/system.hcl",
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
