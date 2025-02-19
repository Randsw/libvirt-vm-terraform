prefix = "dev"

image = {
  name = "ubuntu-noble"
  url  = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

domains = [
  {
    name   = "1"
    cpu    = 1
    ram    = 512
    disk   = 10 * 1024 * 1024 * 1024,
    bridge = "virbr0"
  },
  {
    name   = "2"
    cpu    = 2
    ram    = 1024
    disk   = 20 * 1024 * 1024 * 1024,
    bridge = "virbr0"
  }
]