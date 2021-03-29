module "memtier" {
  source            = "github.com/Redislabs-Solution-Architects/terraform_aws_memtier_benchmark"
  region            = var.aws_region
  linux_ami         = var.linux_ami
  instance_type     = var.instance_type
  ssh_key_name      = random_string.ssh_key_name.result
  security_group_id = aws_security_group.redisgeek.id
}
