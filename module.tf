module "acre" {
  source = "github.com/redisgeek/acre-terraform-simple"
}

module "riot" {
  source            = "github.com/redisgeek/run_RIOT"
  region            = var.aws_region
  linux_ami         = var.linux_ami
  instance_type     = var.instance_type
  ssh_key_name      = aws_key_pair.generated_key.key_name
  security_group_id = aws_security_group.redisgeek.id
}

module "memtier" {
  source            = "github.com/redisgeek/terraform_aws_memtier_benchmark"
  aws_region        = var.aws_region
  linux_ami         = var.linux_ami
  instance_type     = var.instance_type
  ssh_key_name      = aws_key_pair.generated_key.key_name
  security_group_id = aws_security_group.redisgeek.id
}
