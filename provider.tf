terraform {
  required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "> 0.8"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
  }
}
