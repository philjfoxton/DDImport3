data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "helm_repository" "elastic" {
  name = "elastic"
  url  = "https://helm.elastic.co"
}

data "aws_caller_identity" "current" {}

data "helm_repository" "gitlab" {
  name = "gitlab"
  url  = "https://charts.gitlab.io"
}

data "aws_kms_secrets" "gitlab_token" {
  secret {
    name    = "gitlab"
    payload = "AQICAHgI6guE+J26KRDmKmotyhUiKRFnRLoVcUOdybzZqrgFbwEy1lM2Xx3i8FOYcAPWc3UoAAAAcjBwBgkqhkiG9w0BBwagYzBhAgEAMFwGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMB8xG5TyIOwfYjtrWAgEQgC83qS/+Fb2uPH+QyczYM/s73WAzoQNDD0bplLRdYF2RYQt3OKqsDDS+4jF31g54MQ=="
  }
}

data "helm_repository" "incubator" {
  name = "incubator"
  url  = "http://kubernetes-charts-incubator.storage.googleapis.com"
}

