locals {
  acre_host     = split("/", module.acre.redisgeek_config.cluster[0].id)[8]
  acre_location = module.acre.redisgeek_config.cluster[0].location
  acre_port     = module.acre.redisgeek_config.database[0].port
  acre_fqdn     = "${local.acre_host}.${local.acre_location}.redisenterprise.cache.azure.net"
  ec_node       = aws_elasticache_cluster.source.cache_nodes[0]
}

//output "run_riot" {
//    value = "ssh -i ~/.ssh/${var.ssh_key_name}.pem ${module.riot.user}@${module.riot.host} '${module.riot.program} -h ${local.ec_node.address} -p ${local.ec_node.port}  replicate -h ${local.acre_fqdn} -p ${local.acre_port} --idle-timeout 10000 --live --tls --no-verify-peer -a PASSWORD'"
//    description = "command to run riot - need to paste in value for PASSWORD from redis_insight-Password"
//}
//
//output "run_memtier" {
//    value = "ssh -i ~/.ssh/${var.ssh_key_name}.pem ${module.memtier.user}@${module.memtier.host} '${module.memtier.program} -s ${local.ec_node.address} -p ${local.ec_node.port}'"
//    description = "command to run memtier against the elasticache instance"
//}

output "redis_insight-Host" {
  value       = local.acre_fqdn
  description = "Host value for Redis Insight configuration"
}

output "redis_insight-Port" {
  value       = local.acre_port
  description = "Port value for Redis Insight configuration"
}

output "redis_insight-Password" {
  value       = "Value must be retrieved by going to Azure Resource Manager, searching for ${local.acre_host} and selecting the 'Access Keys'}"
  description = "Password value for Redis Insight configuration"
}



