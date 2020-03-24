module "external_dns_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"


  name        = "external_dns"
  path        = "/"
  description = "External dns polocy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

module "auth_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "auth_service_policy"
  path    = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${data.terraform_remote_state.s3.outputs.buckets["881792143615-pfm-production-goals-images-eu-west-1"]}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "sqs:*"
      ],
      "Resource": [
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SaveCpr"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SaveCpr-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SendUserNotification"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SendUserNotification-dlq"]}"
      ]
    }
  ]
}
EOF
}

module "connections_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "connections_service_policy"
  path    = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:*"
      ],
      "Resource": [
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SaveCpr"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SaveCpr-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-UserTokenConnected"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-UserTokenConnected-dlq"]}"
      ]
    }
  ]
}
EOF
}

module "goals_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "goals_service_policy"
  path    = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${data.terraform_remote_state.s3.outputs.buckets["881792143615-pfm-production-goals-images-eu-west-1"]}"
      ]
    }
  ]
}
EOF
}

module "notifications_api_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "notifications_api_policy"
  path    = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:*"
      ],
      "Resource": [
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SavePushToken"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SavePushToken-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-DeletePushToken"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-DeletePushToken-dlq"]}"
      ]
    }
  ]
}
EOF
}
module "notifications_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "notifications_service_policy"
  path    = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:*"
      ],
      "Resource": [
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SavePushToken"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SavePushToken-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-DeletePushToken"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-DeletePushToken-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SendUserNotification"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SendUserNotification-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SaveNotificationsUserInfo"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SaveNotificationsUserInfo-dlq"]}"
      ]
    }
  ]
}
EOF
}

module "obpexporter_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "obpexporter_service_policy"
  path    = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:*"
      ],
      "Resource": [
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SyncTransactions"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SyncTransactions-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-UserTokenConnected"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-UserTokenConnected-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SendUserNotification"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SendUserNotification-dlq"]}"
      ]
    }
  ]
}
EOF
}

module "transactions_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "transactions_service_policy"
  path    = "/"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sqs:*"
      ],
      "Resource": [
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-Production-SyncTransactions"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-Production-SyncTransactions-dlq"]}"
      ]
    }
  ]
}
EOF
}
