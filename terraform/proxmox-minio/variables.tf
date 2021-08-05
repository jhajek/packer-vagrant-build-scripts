#https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
variable "pm_api_url" {}

variable "yourinitials_node1" {}

variable "yourinitials_node2" {}

variable "yourinitials_node3" {}

variable "yourinitials_node4" {}

variable "pm_api_token_id" {
  sensitive = true
}

variable "pm_api_token_secret" {
  sensitive = true
}

variable "error_level" {
  default = "debug"
}

variable "pm_log_enable" {}

variable "pm_parallel" {}

variable "pm_timeout" {}

variable "pm_log_file" {}

variable "numberofvms" {}

variable "desc_node1" {}

variable "desc_node2" {}

variable "desc_node3" {}

variable "desc_node4" {}

variable "target_node" {}

variable "template_to_clone" {}

variable "memory" {}

variable "cores" {}

variable "sockets" {}

variable "storage" {}

variable "disk_size" {}

variable "data_disk_size" {}

variable "keypath" {}

variable "additional_wait" {
  default = 30
}

variable "clone_wait" {
  default = 30
}

variable "consulip" {}
