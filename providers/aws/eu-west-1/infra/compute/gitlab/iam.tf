data "aws_iam_policy_document" "policy_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "gitlab_runner" {
  # allow building amis
  statement {
    sid    = "NonResourceBasedReadOnlyPermissions"
    effect = "Allow"

    actions = [
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeRegions",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:GetPasswordData",
      "eks:*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "NonResourceBasedWritePermissions"
    effect = "Allow"

    actions = [
      "ec2:CopyImage",
      "ec2:CreateImage",
      "ec2:CreateFleet",
      "ec2:CreateKeypair",
      "ec2:CreateLaunchTemplate",
      "ec2:DeleteLaunchTemplate",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteKeyPair",
      "ec2:DeleteSnapshot",
      "ec2:DeleteVolume",
      "ec2:DeregisterImage",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifySnapshotAttribute",
      "ec2:RegisterImage",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:StopInstances",
      "ec2:TerminateInstances",

    ]

    resources = ["*"]
  }

  statement {
    sid       = "AllowPassingPackerRoleToInstance"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowInstanceActions"
    effect = "Allow"

    actions = [
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:TerminateInstances",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances",
      "ec2:DescribeInstances",
      "ec2:CreateTags",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = ["*"]

  }

  statement {
    sid       = "AllowKMSDecrypt"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = [var.terraform_remote_state_kms_key]
  }


  statement {
    sid    = "AllowPushPullECR"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]

    resources = ["*"]
  }

  statement {
    sid = "SSMPolicy"

    actions = [
      "ssm:*",
    ]
    resources = ["*"]

  }

  statement {
    sid = "SSMKMSPolicy"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "gitlab_runner" {
  name               = "gitlab_runner"
  assume_role_policy = data.aws_iam_policy_document.policy_assume.json
}

resource "aws_iam_role_policy" "gitlab_runner" {
  name   = "GitlabRunnerPolicy"
  role   = aws_iam_role.gitlab_runner.name
  policy = data.aws_iam_policy_document.gitlab_runner.json
}

resource "aws_iam_instance_profile" "gitlab_runner" {
  name = aws_iam_role.gitlab_runner.name
  role = aws_iam_role.gitlab_runner.name
}
