#https://registry.terraform.io/providers/Telmate/proxmox/latest/docs
variable "pm_api_url" {}

#variable "pm_user" {}

#variable "pm_password" {
#  sensitive = true
#}
variable "yourinitials" {}

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

variable "desc" {}

variable "target_node"{}

variable "template_to_clone" {}

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

variable "pm_log_enable" {
  default = true
}

variable "pm_log_file" {}

variable "pm_parallel" {}

variable "pm_timeout" {
  default = 300
}

variable "yourinitials" {
  default = "jrh"
}
