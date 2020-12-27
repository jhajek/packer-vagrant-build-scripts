variable "headless-val" {
  type    = string
  default = "false"
}

variable "ip" {
  type    = string
  default = "172.168.1.201"
}

variable "mac-addr" {
  type    = string
  default = "90:e2:ba:2e:b0:70"
}

variable "password" {
  type    = string
  default = "cluster"
}

variable "prxmx-url" {
  type    = string
  default = "https://172.16.1.62:8006/api2/json"
}

variable "storagepool" {
  type    = string
  default = "datadisk1"
}

variable "storagepooltype" {
  type    = string
  default = "lvm"
}

variable "uname" {
  type    = string
  default = "root@pam"
}

variable "vmname" {
  type    = string
  default = "ubuntu-18045-prxmx25"
}

variable "node" {
  type    = string
  default = "pve"
}