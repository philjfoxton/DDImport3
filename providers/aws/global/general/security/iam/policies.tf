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

module "connections_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "connections_service_policy"
  path    = "/"
}

module "goals_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "goals_service_policy"
  path    = "/"
}

module "notifications_api_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "notifications_api_policy"
  path    = "/"
}

module "notifications_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "notifications_service_policy"
  path    = "/"
}

module "obpexporter_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "obpexporter_service_policy"
  path    = "/"
}

module "transactions_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "transactions_service_policy"
  path    = "/"
}

module "statements_service_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"
  name    = "statements_service_policy"
  path    = "/"
}