variable "pm_api_url" {}

variable "pm_user" {}

variable "pm_password" {
  sensitive = true
}

variable "numberofvms" {}

variable "desc" {}

variable "target_node"{}

variable "template_to_clone" {}

variable "memory"{}

variable "cores"{}

variable "sockets"{}

variable "storage" {}

variable "disk_size"{}

variable "additional_wait" {}

variable "keypath" {}
