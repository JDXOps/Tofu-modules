resource "aws_eks_fargate_profile" "karpenter" {
  count                  = var.enable_karpenter ? 1 : 0
  subnet_ids             = var.private_subnet_ids
  cluster_name           = data.aws_eks_cluster.eks_cluster[0].name
  fargate_profile_name   = "karpenter"
  pod_execution_role_arn = aws_iam_role.fargate[0].arn
  selector {
    namespace = var.karpenter_namespace
  }

  selector {
    namespace = "kube-system"
    labels    = { k8s-app = "kube-dns" }

  }

}

resource "aws_iam_role" "fargate" {
  count              = var.enable_karpenter ? 1 : 0
  description        = "IAM Role for Fargate profile to run Karpenter pods"
  assume_role_policy = data.aws_iam_policy_document.fargate[0].json
  name               = "${data.aws_eks_cluster.eks_cluster[0].name}-karpenter-fargate"
}

data "aws_iam_policy_document" "fargate" {
  count = var.enable_karpenter ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }

  }
}

resource "aws_iam_role_policy_attachment" "fargate_attach_podexecution" {
  count      = var.enable_karpenter ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate[0].name

}


resource "aws_iam_role_policy_attachment" "fargate_attach_cni" {
  count      = var.enable_karpenter ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.fargate[0].name

}