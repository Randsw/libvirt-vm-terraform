
output "vms_info" {
  description = "General information about created VMs"
  value = [
    for vm in libvirt_domain.vm : {
      id = vm.name
      ip = vm.network_interface[0].addresses.0
    }
  ]
}

locals {
  inventory_rendered_content = templatefile("${path.module}/inventory_ansible.tftpl", 
  {
    vms = "${libvirt_domain.vm}"
  })
}

resource "local_file" "inventories" {
  content = local.inventory_rendered_content
  filename = "${path.module}/ansible/inventories/linux_vm/hosts.yml"
}