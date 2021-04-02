resource "random_string" "ssh_key_name" {
  length  = 8
  number  = false
  special = false
  upper   = false
}

resource "random_string" "sg_suffix" {
  length  = 8
  number  = false
  special = false
  upper   = false
}

resource "random_string" "elasticache_suffix" {
  length  = 8
  number  = false
  special = false
  upper   = false
}
