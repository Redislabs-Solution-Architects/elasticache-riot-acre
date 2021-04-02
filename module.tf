module "acre" {
  source          = "github.com/redisgeek/acre-terraform-simple"
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

module "riot" {
  source            = "github.com/Redislabs-Solution-Architects/run_RIOT"
  region            = var.aws_region
  linux_ami         = var.linux_ami
  instance_type     = var.instance_type
  ssh_key_name      = aws_key_pair.generated_key.key_name
  security_group_id = aws_security_group.redisgeek.id
}

module "memtier" {
  source            = "github.com/Redislabs-Solution-Architects/terraform_aws_memtier_benchmark"
  region            = var.aws_region
  linux_ami         = var.linux_ami
  instance_type     = var.instance_type
  ssh_key_name      = aws_key_pair.generated_key.key_name
  security_group_id = aws_security_group.redisgeek.id
}
