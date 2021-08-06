//  variables.pkr.hcl

// For those variables that you don't provide a default for, you must
// set them from the command line, a var-file, or the environment.

# This is the name of the node in the Cloud Cluster where to deploy the virtual instances
variable "NODENAME" {
  type    = string
  default = ""
}

variable "USERNAME" {}

variable "PROXMOX_TOKEN" {}

variable "URL" {
  type = string
  # https://x.x.x.x:8006/api2/json
  default = ""
}

variable "MEMORY" {
  type    = string
  default = "4192"
}

variable "DISKSIZE" {
  type    = string
  default = "20G"
}

variable "STORAGEPOOL" {
  type    = string
  default = "datadisk5"
}

variable "NUMBEROFCORES" {
  type    = string
  default = "1"
}

variable "KEYNAME" {
  type = string
  # Name of public key to insert to the template 
  default = ""
}

# This is the name of the Virtual Machine Template you want to create
variable "RIEMANNA" {
  type    = string
  default = "jrh-riemanna"
}

# This is the name of the Virtual Machine Template you want to create
variable "RIEMANNB" {
  type    = string
  default = "jrh-riemannb"
}

# This is the name of the Virtual Machine Template you want to create
variable "RIEMANNMC" {
  type    = string
  default = "jrh-riemannmc"
}

# This is the name of the Virtual Machine Template you want to create
variable "GRAPHITEA" {
  type    = string
  default = "jrh-graphitea"
}

# This is the name of the Virtual Machine Template you want to create
variable "GRAPHITEB" {
  type    = string
  default = "jrh-graphiteb"
}

# This is the name of the Virtual Machine Template you want to create
variable "GRAPHITEMC" {
  type    = string
  default = "jrh-graphitemc"
}