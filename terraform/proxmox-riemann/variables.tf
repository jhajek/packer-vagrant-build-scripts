#https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
variable "pm_api_url" {}

variable "yourinitials_a" {}

variable "yourinitials_b" {}

variable "yourinitials_mc" {}

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

variable "desc_a" {}

variable "desc_b" {}

variable "desc_mc" {}

variable "target_node"{}

variable "template_to_clone_a" {}

variable "template_to_clone_b" {}

variable "template_to_clone_mc" {}

variable "memory"{}

variable "cores"{}

variable "sockets"{}

variable "storage" {}

variable "disk_size"{}

variable "keypath" {}

variable "additional_wait" {
  default = 30
}

variable "clone_wait" {
  default = 30
}

variable "consulip" {}
