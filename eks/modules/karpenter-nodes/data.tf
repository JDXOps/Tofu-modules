data "aws_eks_cluster" "eks_cluster" {
  count = var.enable_karpenter ? 1 : 0
  name  = var.name
}

data "aws_region" "current" {}

data "aws_iam_openid_connect_provider" "cluster_oidc_provider" {
  arn = var.cluster_oidc_arn
}