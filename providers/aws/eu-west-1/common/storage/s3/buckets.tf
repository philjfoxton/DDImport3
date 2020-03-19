resource "aws_s3_bucket" "pfm_buckets" {
  count  = length(local.formated_buckets)
  bucket = local.formated_buckets[count.index]
  acl    = "private"
}

