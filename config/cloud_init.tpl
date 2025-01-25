#cloud-config
ssh_pwauth: false
chpasswd:
  list: |
     root:linux
  expire: False
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock-passwd: false
    ssh_pwauth: false
    chpasswd: { expire: False }
    ssh_authorized_keys:
      - ${ssh_public_key}
package_update: true
packages:
  - qemu-guest-agent
write_files:
  - path: /etc/cloud/cloud.cfg.d/99-custom-networking.cfg
    permissions: '0644'
    content: |
      network: {config: disabled}
  - path: /etc/netplan/my-new-config.yaml
    permissions: '0644'
    content: |
      network:
        version: 2
        ethernets:
            eth:
                match:
                    name: en*
                dhcp4: true
runcmd:
  - [ rm, /etc/netplan/50-cloud-init.yaml ]
  - [ netplan, generate ]
  - [ netplan, apply ]
  - [ systemctl, enable, --now, qemu-guest-agent ]