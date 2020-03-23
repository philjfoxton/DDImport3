resource "aws_ecr_repository" "repositories" {
  name                 = local.repositories[count.index]
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  count = length(local.repositories)
}

