# Prefix
variable "prefix" {
  type    = string
  default = "dev"
}

# Project pool path
variable "pool_path" {
  type    = string
  default = "/var/lib/libvirt/"
}

# OS image 
variable "image" {
  type = object({
    name = string
    url  = string
  })
}

variable "domains" {
  description = "List of VMs with specified parameters"
  type = list(object({
    name   = string,
    cpu    = number,
    ram    = number,
    disk   = number,
    bridge = string
  }))
}