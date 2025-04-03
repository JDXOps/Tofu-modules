resource "aws_iam_role" "karpenter" {
  count              = var.enable_karpenter ? 1 : 0
  description        = "IAM Role for Karpenter Controller (pod) to assume"
  assume_role_policy = data.aws_iam_policy_document.karpenter_assume_role[0].json
  name               = "${data.aws_eks_cluster.eks_cluster[0].name}-karpenter-controller"
  inline_policy {
    policy = data.aws_iam_policy_document.karpenter[0].json
    name   = "karpenter"
  }

}


data "aws_iam_policy_document" "karpenter_assume_role" {
  count = var.enable_karpenter ? 1 : 0
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:${var.karpenter_namespace}:${var.karpenter_service_account}"]
      variable = "${data.aws_iam_openid_connect_provider.cluster_oidc_provider.url}:sub"
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "${data.aws_iam_openid_connect_provider.cluster_oidc_provider.url}:aud"
    }

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.cluster_oidc_provider.arn]
    }

  }
}

data "aws_iam_policy_document" "karpenter" {
  count = var.enable_karpenter ? 1 : 0
  statement {
    resources = ["*"]
    actions   = ["ec2:DescribeImages", "ec2:RunInstances", "ec2:DescribeSubnets", "ec2:DescribeSecurityGroups", "ec2:DescribeLaunchTemplates", "ec2:DescribeInstances", "ec2:DescribeInstanceTypes", "ec2:DescribeInstanceTypeOfferings", "ec2:DescribeAvailabilityZones", "ec2:DeleteLaunchTemplate", "ec2:CreateTags", "ec2:CreateLaunchTemplate", "ec2:CreateFleet", "ec2:DescribeSpotPriceHistory", "pricing:GetProducts", "ssm:GetParameter"]
    effect    = "Allow"
  }

  statement {
    resources = ["*"]
    actions   = ["ec2:TerminateInstances", "ec2:DeleteLaunchTemplate"]
    effect    = "Allow"

    # Make sure Karpenter can only delete nodes that it has provisioned
    condition {

      test = "StringEquals"

      values = [data.aws_eks_cluster.eks_cluster[0].name]

      variable = "ec2:ResourceTag/karpenter.sh/discovery"

    }

  }

  statement {
    resources = [data.aws_eks_cluster.eks_cluster[0].arn]
    actions   = ["eks:DescribeCluster"]
    effect    = "Allow"

  }

  statement {
    resources = [aws_iam_role.eks_node[0].arn]
    actions   = ["iam:PassRole"]
    effect    = "Allow"

  }

  # Optional: Interrupt Termination Queue permissions, provided by AWS SQS

  statement {
    resources = [aws_sqs_queue.karpenter[0].arn]
    actions   = ["sqs:DeleteMessage", "sqs:GetQueueUrl", "sqs:GetQueueAttributes", "sqs:ReceiveMessage"]
    effect    = "Allow"

  }

}