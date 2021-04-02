resource "aws_key_pair" "generated_key" {
  key_name   = format("redisgeek-%s", random_string.ssh_key_name.result)
  public_key = tls_private_key.example.public_key_openssh
}
