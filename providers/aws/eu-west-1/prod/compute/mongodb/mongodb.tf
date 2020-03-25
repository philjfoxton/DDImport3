module "mongo_cluster" {
  source              = "github.com/cloudposse/terraform-aws-documentdb-cluster?ref=0.3.0"
  name                = local.name
  subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  cluster_size        = 3
  instance_class      = "db.r5.large"
  allowed_cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  master_password     = data.aws_kms_secrets.mongo_credentials.plaintext["password"]
  master_username     = data.aws_kms_secrets.mongo_credentials.plaintext["username"]
  cluster_parameters = [
    {
      apply_method = "pending-reboot"
      name         = "tls"
      value        = "disabled"
    }
  ]
}

