variable "access_key" {
  type =  string
  default = ""
  sensitive = true
}

variable "secret_key" {
  type =  string
  default = ""
  sensitive = true
}

variable "s3-bucket-name" {
  # make sure to change default value to use your initials
  type =  string
  default = "ova-bucket-jrh"
  sensitive = true
}

variable "region" {
  # make sure to change default value to use your initials
  type =  string
  default = "us-east-2"
}
