locals {
  buckets = [
    "pfm-categories-icons",
  ]
  formated_buckets = formatlist("%s-%s-%s", data.aws_caller_identity.current.account_id, local.buckets, var.aws_region)
}
