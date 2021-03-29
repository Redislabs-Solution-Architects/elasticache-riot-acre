module "acre" {
  source          = "github.com/redisgeek/acre-terraform-simple"
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}