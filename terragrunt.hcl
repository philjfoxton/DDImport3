#iam_role = "arn:aws:iam::860177160240:role/terraform"


remote_state {
  backend = "s3"

  config = {
    bucket         = "pfm-prod-eu-west-1-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-1:881792143615:key/72dca630-d71c-4bd6-87f8-c5132d49f48e"
    dynamodb_table = "pfm-terraform-lock"
    region         = "eu-west-1"
  }
}

locals {
  aws_region = "eu-west-1"
}

inputs = {
  aws_region = local.aws_region

  terraform_remote_state_s3_bucket      = "pfm-prod-${local.aws_region}-terraform-state"
  terraform_remote_state_dynamodb_table = "pfm-terraform-lock"
  terraform_remote_state_file_name      = "terraform.tfstate"
  terraform_remote_state_kms_key        = "arn:aws:kms:eu-west-1:881792143615:key/72dca630-d71c-4bd6-87f8-c5132d49f48e"
}
