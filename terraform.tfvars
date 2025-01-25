prefix = "dev"

image = {
  name = "ubuntu-noble"
  url  = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

vm = {
  bridge = "virbr0"
  cpu    = 2
  disk   = 20 * 1024 * 1024 * 1024
  ram    = 2048
}