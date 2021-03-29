resource "random_string" "ssh_key_name" {
  length  = 8
  number  = false
  special = false
  upper   = false
}
