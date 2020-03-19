locals {
  eks_oidc_provider = trim(data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url, "https://")

}