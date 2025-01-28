provider "libvirt" {
  # Configuration options
  uri = "qemu:///system"
}

resource "libvirt_pool" "pool" {
  name = "${var.prefix}-pool"
  type = "dir"
  target {
      path = "${var.pool_path}${var.prefix}-pool"
  }
}

// Image volume
resource "libvirt_volume" "image" {
  name   = var.image.name
  format = "qcow2"
  pool   = libvirt_pool.pool.name
   source = "${path.module}/noble-server-cloudimg-amd64.img"
}

resource "libvirt_volume" "root" {
  count = length(var.domains)

  name           = "${var.prefix}-${var.domains[count.index].name}-root"
  pool           = libvirt_pool.pool.name
  base_volume_id = libvirt_volume.image.id
  size           = var.domains[count.index].disk
}


data "template_file" "user_data" {
  template = file("${path.module}/config/cloud_init.tpl")
   vars = {
    ssh_public_key = "${tls_private_key.ssh_keys.public_key_openssh}"
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/config/network_config.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  pool           = libvirt_pool.pool.name
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
}

resource "libvirt_domain" "vm" {
  count = length(var.domains)

  name   = "${var.prefix}-${var.domains[count.index].name}"
  vcpu   = var.domains[count.index].cpu
  memory = var.domains[count.index].ram

  qemu_agent = true

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    bridge         = var.domains[count.index].bridge
    wait_for_lease = true
  }
  disk {
    volume_id = libvirt_volume.root[count.index].id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
}