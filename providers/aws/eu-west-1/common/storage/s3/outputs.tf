output "buckets" {
  value = {
  for s3 in aws_s3_bucket.pfm_buckets :
  replace(s3.bucket, "/[.]$/", "") => replace(s3.arn, "/[.]$/", "")
  }
}
