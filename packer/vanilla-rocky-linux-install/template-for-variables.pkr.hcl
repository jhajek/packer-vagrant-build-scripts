variable "headless_build" {
  type =  bool
  default = false
}

variable "memory_amount" {
  type =  string
  default = "2048"
}

variable "build_location" {
  type = string
  default = "../build/{{.BuildName}}-{{.Provider}}-{{timestamp}}.box"
}