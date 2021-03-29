resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
