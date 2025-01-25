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

// Inage volume
resource "libvirt_volume" "image" {
  name   = var.image.name
  format = "qcow2"
  pool   = libvirt_pool.pool.name
   source = "${path.module}/noble-server-cloudimg-amd64.img"
}

// VM volume
resource "libvirt_volume" "root" {
  name           = "${var.prefix}-root"
  pool           = libvirt_pool.pool.name
  base_volume_id = libvirt_volume.image.id
  size           = var.vm.disk
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
  name   = "${var.prefix}-1"
  memory = var.vm.ram
  vcpu   = var.vm.cpu

  cloudinit = libvirt_cloudinit_disk.commoninit.id

#   network_interface {
#     network_name = "default"
#     wait_for_lease = true
#   }

  network_interface {
    bridge         = var.vm.bridge
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.root.id
  }

  qemu_agent = true

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}
