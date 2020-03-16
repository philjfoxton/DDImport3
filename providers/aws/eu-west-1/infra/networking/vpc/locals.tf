locals {
  vpc_azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc_cidr            = "10.1.0.0/16"
  vpc_private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  vpc_public_subnets  = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
}
