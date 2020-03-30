output "external_dns_role" {
  value = module.external_dns_role.this_iam_role_arn
}

output "connections_service_role" {
  value = module.connections_service.this_iam_role_arn
}

output "goals_service_role" {
  value = module.goals_service.this_iam_role_arn
}

output "notifications_api_role" {
  value = module.notifications_api.this_iam_role_arn
}

output "notifications_service_role" {
  value = module.notifications_service.this_iam_role_arn
}

output "obpexporter_service_role" {
  value = module.obpexporter_service.this_iam_role_arn
}

output "transactions_service_role" {
  value = module.transactions_service.this_iam_role_arn
}

output "statements_service_role" {
  value = module.statements_service.this_iam_role_arn
}