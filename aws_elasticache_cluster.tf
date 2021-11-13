resource "aws_elasticache_cluster" "source" {
  cluster_id         = format("redisgeek-%s", random_string.elasticache_suffix.result)
  engine             = "redis"
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  port               = 6379
  security_group_ids = [aws_security_group.redisgeek.id]
  tags = {
    name = format("redisgeek-%s", random_string.elasticache_suffix.result)
  }
}
