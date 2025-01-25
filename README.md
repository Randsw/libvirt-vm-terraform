# Create QEMU-KVM virtual machines using Terraform

## Requirements

- KVM
- QEMU
- Libvirt
- Terraform

## Prepare libvirt

To avoid `Could not open '/var/lib/libvirt/images/<FILE_NAME>': Permission denied` add `security_driver = "none"` in `/etc/libvirt/qemu.conf` and run `sudo systemctl restart libvirtd` to restart the daemon.

## Terraform

### Prepare

Download `Terraform` modules:

```bash
terraform init
```

Set desired `CPU` and `memory` in `terraform.tfvars`

### Create VM

```bash
terraform apply
```

### Access VM

```bash
ssh -i ssh/vm-private-key.rsa ubuntu@<vm-ip-address>
```

### Delete VM

```bash
terraform destroy
```
