###############################################################################################
# This template demonstrates a Terraform plan to deploy one CentOS Stream instance.
# Run this by typing: terraform apply -parallelism=1
###############################################################################################
resource "random_id" "id" {
  byte_length = 8
}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle#example-usage
resource "random_shuffle" "datadisk" {
  input        = ["datadisk2","datadisk3"]
  result_count = 1
}

resource "proxmox_vm_qemu" "vanilla-centos" {
  count           = var.numberofvms
  name            = "${var.yourinitials}-vm${count.index}"
  desc            = var.desc
  target_node     = var.target_node
  clone           = var.template_to_clone
  os_type         = "cloud-init"
  memory          = var.memory
  scsihw          = "virtio-scsi-pci"
  cores           = var.cores
  sockets         = var.sockets
  bootdisk        = "virtio0"
  boot            = "cdn"
  agent           = 1
  additional_wait = var.additional_wait
  clone_wait      = var.clone_wait

  ipconfig0 = "ip=dhcp"
  ipconfig1 = "ip=dhcp"

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }

  disk {
    type    = "virtio"
    storage = random_shuffle.datadisk.result[0]
    size    = var.disk_size
  }

  provisioner "remote-exec" {
    # This inline provisioner is needed to accomplish the final fit and finish of your deployed
    # instance and condigure the system to register the FQDN with the Consul DNS system
    inline = [
      "sudo hostnamectl set-hostname ${var.yourinitials}-vm${count.index}",
      "sudo sed -i 's/changeme/${random_id.id.dec}${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/replace-name/${var.yourinitials}-vm${count.index}/' /etc/consul.d/system.hcl",
      "sudo sed -i 's/#datacenter = \"my-dc-1\"/datacenter = \"rice-dc-1\"/' /etc/consul.d/consul.hcl",
      "echo 'retry_join = [\"${var.consulip}\"]' | sudo tee -a /etc/consul.d/consul.hcl",
      "IP=`hostname -I | awk '{print $1}'`", 
      "sudo sed -i 's/#bind_addr = \"0.0.0.0\"/bind_addr = \"${var.ipconfig0.count.index}\"/' /etc/consul.d/consul.hcl",
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
