resource "aws_iam_role" "workers" {
  name_prefix        = "${local.cluster_name}-worker-"
  assume_role_policy = data.aws_iam_policy_document.workers_assume_role_policy.json
}

resource "aws_iam_instance_profile" "workers" {
  name_prefix = "${local.cluster_name}-workers-"
  role        = aws_iam_role.workers.name
}

resource "aws_iam_policy" "workers_autoscaling" {
  name_prefix = "${local.cluster_name}-workers-autoscaling-"
  description = "EKS worker node autoscaling policy for cluster ${local.cluster_name}"
  policy      = data.aws_iam_policy_document.workers_autoscaling.json
}

resource "aws_iam_role_policy_attachment" "workers_autoscaling" {
  policy_arn = aws_iam_policy.workers_autoscaling.arn
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers" {
  count      = length(local.default_eks_workers_iam_policies)
  role       = aws_iam_role.workers.name
  policy_arn = local.default_eks_workers_iam_policies[count.index]
}