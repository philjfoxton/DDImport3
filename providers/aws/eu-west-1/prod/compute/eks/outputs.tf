output "kubeconfig" {
  value = module.prod_eks.kubeconfig
}

output "kubeconfig_filename" {
  value = module.prod_eks.kubeconfig_filename
}

output "cluster_name" {
  value = module.prod_eks.cluster_id
}

output "cluster_endpoint" {
  value = module.prod_eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.prod_eks.cluster_certificate_authority_data
}

output "cluster_security_group_id" {
  value = module.prod_eks.cluster_security_group_id
}

output "worker_security_group_id" {
  value = module.prod_eks.worker_security_group_id
}

output "cluster_oidc_issuer_url" {
  value = module.prod_eks.cluster_oidc_issuer_url
}