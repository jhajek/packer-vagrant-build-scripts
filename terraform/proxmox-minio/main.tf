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
  input = ["datadisk1", "datadisk2", "datadisk3", "datadisk4", "datadisk5"]
  result_count = 1 
}

# Create minio node1

resource "proxmox_vm_qemu" "minio-node1" {
  count       = var.numberofvms
  name        = "${var.yourinitials_node1}"
  desc        = var.desc_node1
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

# Initial operating system disk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

# Attached first datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

# Attached second datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

 # Attached third datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  } 

# Attached fourth datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

  provisioner "remote-exec" {
    # This inline provisioner is needed to accomplish the final fit and finish of your deployed
    # instance and condigure the system to register the FQDN with the Consul DNS system
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials_node1}",
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

# Create Minio Node 2

resource "proxmox_vm_qemu" "minio-node2" {
  count       = var.numberofvms
  name        = "${var.yourinitials_node2}"
  desc        = var.desc_node2
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
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

# Attached first datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

# Attached second datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

 # Attached third datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  } 

# Attached fourth datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

  provisioner "remote-exec" {
    # This inline provisioner is needed to accomplish the final fit and finish of your deployed
    # instance and condigure the system to register the FQDN with the Consul DNS system
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials_node2}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials_node2}/' /etc/consul.d/system.hcl",
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

# Create Minio Node 3

resource "proxmox_vm_qemu" "minio-node3" {
  count       = var.numberofvms
  name        = "${var.yourinitials_node3}"
  desc        = var.desc_node3
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
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

# Attached first datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

# Attached second datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

 # Attached third datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  } 

# Attached fourth datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

  provisioner "remote-exec" {
    # This inline provisioner is needed to accomplish the final fit and finish of your deployed
    # instance and condigure the system to register the FQDN with the Consul DNS system
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials_node3}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials_node3}/' /etc/consul.d/system.hcl",
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

# Create Minio Node 4

resource "proxmox_vm_qemu" "minio-node4" {
  count       = var.numberofvms
  name        = "${var.yourinitials_node4}"
  desc        = var.desc_node4
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
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.disk_size
  }

# Attached first datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

# Attached second datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

 # Attached third datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  } 

# Attached fourth datadisk 
  disk {
    type    = "virtio"
    storage = "${random_shuffle.datadisk.result[0]}"
    size    = var.data_disk_size
  }

  provisioner "remote-exec" {
    # This inline provisioner is needed to accomplish the final fit and finish of your deployed
    # instance and condigure the system to register the FQDN with the Consul DNS system
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials_node4}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials_node4}/' /etc/consul.d/system.hcl",
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