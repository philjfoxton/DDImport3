output "endpoint" {
  value = module.mongo_cluster.endpoint
}

output "security_group" {
  value = module.mongo_cluster.security_group_id
}