resource "aws_security_group_rule" "sg_eks_api_prod" {
  description       = "Allow access EKS cluster API over prod VPC"
  protocol          = "tcp"
  security_group_id = module.prod_eks.cluster_security_group_id
  cidr_blocks       = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  from_port         = 443
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "sg_eks_workers_ssh_prod" {
  description       = "Allow SSH to EKS workers over prod VPC"
  protocol          = "tcp"
  security_group_id = module.prod_eks.worker_security_group_id
  cidr_blocks       = [data.terraform_remote_state.vpc.outputs.vpc_cidr]
  from_port         = 22
  to_port           = 22
  type              = "ingress"
}
