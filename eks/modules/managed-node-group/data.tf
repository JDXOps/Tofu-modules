data "aws_eks_cluster" "eks_cluster" {
  name = var.name
}

data "aws_region" "current" {}