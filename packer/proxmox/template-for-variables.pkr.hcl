//  variables.pkr.hcl

// For those variables that you don't provide a default for, you must
// set them from the command line, a var-file, or the environment.

variable "NODENAME" {
  type =  string
  default = ""
}

variable "USERNAME" {}

variable "PROXMOX_TOKEN" {}

variable "URL" {
  type = string
  # https://x.x.x.x:8006/json/api
  default = ""
}

variable "MEMORY" {
  type = string
  default = "4192"
}

variable "DISKSIZE" {
  type = string
  default = "10G"
}

variable "STORAGEPOOL" {
  type = string
  # choose datapool1, datapool2, datapool3, or datapool4
  default = ""
}

variable "NUMBEROFCORES" {
  type = string
  default = "1"
}

variable "VMNAME" {
  type = string
  default = ""
}