locals {
  acre = {
    host       = module.acre.redisgeek_config.hostname
    port       = module.acre.redisgeek_config.port
    access_key = module.acre.redisgeek_config.access_key
  }
  riot = {
    user    = module.riot.user
    host    = module.riot.host
    program = module.riot.program
  }
  memtier = {
    user    = module.memtier.user
    host    = module.memtier.host
    program = module.memtier.program
  }
  ec = {
    address = aws_elasticache_cluster.source.cache_nodes[0].address
    port    = aws_elasticache_cluster.source.cache_nodes[0].port
  }
  sensitive = {
    private_key_pem = tls_private_key.example.private_key_pem
  }
}

output "run_riot" {
  value       = "ssh -i ./privateKey ${module.riot.user}@${module.riot.host} '${module.riot.program} -h ${aws_elasticache_cluster.source.cache_nodes[0].address} -p ${aws_elasticache_cluster.source.cache_nodes[0].port} replicate --type ds -h ${module.acre.redisgeek_config.hostname} -p ${module.acre.redisgeek_config.port} --idle-timeout 10000 --mode live --tls --no-verify -a ${module.acre.redisgeek_config.access_key}'"
  description = "command to run riot - need to paste in value for PASSWORD from redis_insight-Password"
  sensitive   = true
}

output "run_memtier" {
  value       = "ssh -i ./privateKey ${module.memtier.user}@${module.memtier.host} '${module.memtier.program} -s ${aws_elasticache_cluster.source.cache_nodes[0].address} -p ${aws_elasticache_cluster.source.cache_nodes[0].port}'"
  description = "command to run memtier against the elasticache instance"
  sensitive   = true
}

//output "redis_insight-Host" {
//  value       = local.acre_fqdn
//  description = "Host value for Redis Insight configuration"
//}
//
//output "redis_insight-Port" {
//  value       = local.acre_port
//  description = "Port value for Redis Insight configuration"
//}
//
//output "redis_insight-Password" {
//  value       = "Value must be retrieved by going to Azure Resource Manager, searching for ${local.acre_host} and selecting the 'Access Keys'}"
//  description = "Password value for Redis Insight configuration"
//}

output "sensitive" {
  value     = jsonencode(local.sensitive)
  sensitive = true
}

output "riot" {
  value = jsonencode(local.riot)
}

output "memtier" {
  value = jsonencode(local.memtier)
}

output "ec" {
  value = jsonencode(local.ec)
}

output "acre" {
  value     = jsonencode(local.acre)
  sensitive = true
}
