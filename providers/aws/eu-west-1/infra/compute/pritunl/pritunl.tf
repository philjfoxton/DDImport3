module "pritunl_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.1.0"

  name        = "${local.environment}-pritunl"
  description = "Pritunl sg"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]

  egress_rules = ["all-all"]


  ingress_with_cidr_blocks = [
    {
      from_port   = 11461
      to_port     = 11461
      protocol    = "all"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "pritunl" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.12.0"
  name                        = local.instance_name
  instance_count              = 1
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = local.instance_type
  vpc_security_group_ids      = [module.pritunl_sg.this_security_group_id]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = data.terraform_remote_state.keypair.outputs.infra_key_name
  root_block_device = [
    {
      volume_type           = "gp2"
      volume_size           = 20
      delete_on_termination = false
    },
  ]
  user_data = file("${path.module}/userdata.sh")
}

resource "aws_eip" "pritunl" {
  vpc      = true
  instance = module.pritunl.id[0]
}
