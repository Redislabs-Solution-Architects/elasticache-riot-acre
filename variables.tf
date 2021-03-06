variable "aws_region" {
  description = "Region into which to deploy the EC2 instance"
  default     = "us-east-1"
}

variable "linux_ami" {
  description = "Linux ami to use :: Should work with Redis Labs Sales Account"
  default     = "ami-04ad2567c9e3d7893"

}

variable "instance_type" {
  description = "instance type to use. Default: t3.micro"
  default     = "t3.micro"
}

variable "elasticache_node_type" {
  default     = "cache.t3.micro"
  description = "Elasticache node type. Default: cache.t3.micro"
}
