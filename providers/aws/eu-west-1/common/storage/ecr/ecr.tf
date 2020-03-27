resource "aws_ecr_repository" "repositories" {
  name                 = local.repositories[count.index]
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  count = length(local.repositories)
}


resource "aws_ecr_repository_policy" "nonprod_policy" {
  policy     = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "nonprod",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::063523468743:root"
      },
      "Action": [
        "ecr:*"
      ]
    }
  ]
}
EOF
  repository = aws_ecr_repository.repositories[count.index].name
  count      = length(local.repositories)
}