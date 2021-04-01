locals {
  acre = {
    host = split("/", module.acre.redisgeek_config.cluster[0].id)[8]
    region = module.acre.redisgeek_config.cluster[0].location
    port = module.acre.redisgeek_config.database[0].port
//    fqdn = "${acre.host}.${location}.redisenterprise.cache.azure.net"
  }
  riot = {
    user = module.riot.user
    host = module.riot.host
    program = module.riot.program
  }
  ec = {
    address = aws_elasticache_cluster.source.cache_nodes[0].address
    port = aws_elasticache_cluster.source.cache_nodes[0].port
  }
  sensitive = {
    private_key_pem = tls_private_key.example.private_key_pem
  }
}

//output "run_riot" {
//    value = "ssh -i ~/.ssh/${var.ssh_key_name}.pem ${module.riot.user}@${module.riot.host} '${module.riot.program}-h ${local.ec_node.address} -p ${local.ec_node.port}  replicate -h ${local.acre_fqdn} -p ${local.acre_port} --idle-timeout 10000 --live --tls --no-verify-peer -a PASSWORD'"
//    description = "command to run riot - need to paste in value for PASSWORD from redis_insight-Password"
//}
//
//output "run_memtier" {
//    value = "ssh -i ~/.ssh/${var.ssh_key_name}.pem ${module.memtier.user}@${module.memtier.host} '${module.memtier.program} -s ${local.ec_node.address} -p ${local.ec_node.port}'"
//    description = "command to run memtier against the elasticache instance"
//}

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
  value = jsonencode(local.sensitive)
  sensitive = true
}

output "riot" {
  value = jsonencode(local.riot)
}

output "ec" {
  value = jsonencode(local.ec)
}

output "acre" {
  value = jsonencode(local.acre)
}