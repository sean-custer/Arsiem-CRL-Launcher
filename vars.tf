variable "location" {
  type    = string
  #Change location to datacenter nearest to host
  default = "eastus"
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}
