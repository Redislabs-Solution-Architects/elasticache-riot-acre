module "riot" {
  source            = "github.com/Redislabs-Solution-Architects/run_RIOT"
  region            = var.aws_region
  linux_ami         = var.linux_ami
  instance_type     = var.instance_type
  ssh_key_name      = random_string.ssh_key_name.result
  security_group_id = aws_security_group.redisgeek.id
}
