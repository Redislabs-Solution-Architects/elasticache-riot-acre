variable "aws_region" {
  description = "Region into which to deploy the EC2 instance"
  default     = "us-east-1"
}

variable "linux_ami" {
  description = "Linux ami to use :: Should work with Redis Labs Sales Account"
  default     = "ami-038f1ca1bd58a5790"
}

variable "instance_type" {
  description = "instance type to use. Default: t3.micro"
  default     = "t3.micro"
}

variable "elasticache_node_type" {
  default     = "cache.t3.micro"
  description = "Elasticache node type. Default: cache.t3.micro"
}

variable "client_id" {
  description = "Service Principal to use (az ad sp create-for-rbac ...)"
  sensitive   = true
}

variable "client_secret" {
  description = "Client Secret for Service Principal"
  sensitive   = true
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}
