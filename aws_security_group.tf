resource "aws_security_group" "redisgeek" {
  name        = format("redisgeek-%s", random_string.sg_suffix.result)
  description = "Temporary.  Created by elasticache-riot-acre terraform"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("redisgeek-%s", random_string.sg_suffix.result)
  }
}
