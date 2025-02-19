# Define the SSH key pair resource
# RSA key of size 4096 bits
resource "tls_private_key" "ssh_keys" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_keys.private_key_openssh
  filename        = "ssh/vm-private-key.rsa"
  file_permission = "0400"
}
