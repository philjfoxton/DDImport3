data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket         = var.terraform_remote_state_s3_bucket
    key            = "providers/aws/eu-west-1/prod/compute/eks/${var.terraform_remote_state_file_name}"
    encrypt        = true
    kms_key_id     = var.terraform_remote_state_kms_key
    region         = var.aws_region
    dynamodb_table = var.terraform_remote_state_dynamodb_table
  }
}