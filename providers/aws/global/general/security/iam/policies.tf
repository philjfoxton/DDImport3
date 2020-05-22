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
        "${data.terraform_remote_state.s3.outputs.buckets["881792143615-pfm-nbbproduction-users-avatars-eu-west-1"]}",
        "${data.terraform_remote_state.s3.outputs.buckets["881792143615-pfm-nbbproduction-users-avatars-eu-west-1"]}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "sqs:*"
      ],
      "Resource": [
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SaveCpr"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SaveCpr-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SendUserNotification"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SendUserNotification-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SaveNotificationsUserInfo"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SaveNotificationsUserInfo-dlq"]}"
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
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SaveCpr"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SaveCpr-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-UserTokenConnected"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-UserTokenConnected-dlq"]}"
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
        "${data.terraform_remote_state.s3.outputs.buckets["881792143615-pfm-nbbproduction-goals-images-eu-west-1"]}",
        "${data.terraform_remote_state.s3.outputs.buckets["881792143615-pfm-nbbproduction-goals-images-eu-west-1"]}/*"
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
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SavePushToken"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SavePushToken-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-DeletePushToken"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-DeletePushToken-dlq"]}"
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
        "sqs:*",
        "sns:*"
      ],
      "Resource": [
        "arn:aws:sns:eu-west-1:881792143615:app/GCM/pfm-android",
        "arn:aws:sns:eu-west-1:881792143615:app/APNS/pfm-ios",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SavePushToken"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SavePushToken-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-DeletePushToken"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-DeletePushToken-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SendUserNotification"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SendUserNotification-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SaveNotificationsUserInfo"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SaveNotificationsUserInfo-dlq"]}"
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
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SyncTransactions"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SyncTransactions-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-UserTokenConnected"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-UserTokenConnected-dlq"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SendUserNotification"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SendUserNotification-dlq"]}"
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
        "${data.terraform_remote_state.sqs.outputs.sqs_arn["Pfm-NbbProduction-SyncTransactions"]}",
        "${data.terraform_remote_state.sqs.outputs.sqs_dlq_arn["Pfm-NbbProduction-SyncTransactions-dlq"]}"
      ]
    }
  ]
}
EOF
}


module "alb_ingress_controller_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "2.7.0"

  name        = "pfm_alb_ingress_controller"
  path        = "/"
  description = "Alb ingresss controller"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "acm:GetCertificate"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateSecurityGroup",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DeleteSecurityGroup",
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVpcs",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:RevokeSecurityGroupIngress"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:AddListenerCertificates",
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateRule",
        "elasticloadbalancing:CreateTargetGroup",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteRule",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:DescribeListenerCertificates",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:DescribeSSLPolicies",
        "elasticloadbalancing:DescribeTags",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetGroupAttributes",
        "elasticloadbalancing:DescribeTargetHealth",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:ModifyRule",
        "elasticloadbalancing:ModifyTargetGroup",
        "elasticloadbalancing:ModifyTargetGroupAttributes",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:RemoveListenerCertificates",
        "elasticloadbalancing:RemoveTags",
        "elasticloadbalancing:SetIpAddressType",
        "elasticloadbalancing:SetSecurityGroups",
        "elasticloadbalancing:SetSubnets",
        "elasticloadbalancing:SetWebACL"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole",
        "iam:GetServerCertificate",
        "iam:ListServerCertificates"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cognito-idp:DescribeUserPoolClient"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "waf-regional:GetWebACLForResource",
        "waf-regional:GetWebACL",
        "waf-regional:AssociateWebACL",
        "waf-regional:DisassociateWebACL"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "tag:GetResources",
        "tag:TagResources"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "waf:GetWebACL"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "wafv2:GetWebACL",
        "wafv2:GetWebACLForResource",
        "wafv2:AssociateWebACL",
        "wafv2:DisassociateWebACL"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "shield:DescribeProtection",
        "shield:GetSubscriptionState",
        "shield:DeleteProtection",
        "shield:CreateProtection",
        "shield:DescribeSubscription",
        "shield:ListProtections"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
