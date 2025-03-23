locals {
  cluster_autoscaler_namespace = "kube-system"
  cluster_autoscaler_sa        = "cluster-autoscaler"
}

data "aws_iam_policy_document" "cluster_autoscaler_pod_identity_assume_role" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}


data "aws_iam_policy_document" "cluster_autoscaler_pod_identity" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cluster_autoscaler_pod_identity" {
  count       = var.enable_cluster_autoscaler ? 1 : 0
  name        = "cluster-autoscaler-pod-identity"
  description = "An IAM policy enabling the Kubernetes Cluster Autoscaler to resize EKS clusters"
  policy      = data.aws_iam_policy_document.cluster_autoscaler_pod_identity[0].json
}



resource "aws_iam_role" "cluster_autoscaler_pod_identity" {
  count              = var.enable_cluster_autoscaler ? 1 : 0
  name               = "${data.aws_eks_cluster.eks_cluster.name}-cluster-autosclaer-pod-identity"
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_pod_identity_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_pod_identity" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  policy_arn = aws_iam_policy.cluster_autoscaler_pod_identity[0].arn
  role       = aws_iam_role.cluster_autoscaler_pod_identity[0].name
}


resource "aws_eks_pod_identity_association" "cluster_autoscaler_pod_identity" {
  cluster_name    = data.aws_eks_cluster.eks_cluster.name
  namespace       = local.cluster_autoscaler_namespace
  service_account = local.cluster_autoscaler_sa
  role_arn        = aws_iam_role.cluster_autoscaler_pod_identity[0].arn
}

resource "helm_release" "cluster_autoscaler" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  name       = "cluster-autoscaler"
  namespace  = local.cluster_autoscaler_namespace
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.cluster_autoscaler_version
  wait       = true

  set = [
    {
      name  = "autoDiscovery.clusterName"
      value = data.aws_eks_cluster.eks_cluster.name
    },
    {
      name  = "rbac.serviceAccount.create"
      value = "true"
    },
    {
      name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.cluster_autoscaler_pod_identity[0].arn
    },
    {
      name  = "rbac.serviceAccount.name"
      value = local.cluster_autoscaler_sa
    }

  ]

  depends_on = [aws_eks_node_group.eks_nodegroup, aws_eks_pod_identity_association.cluster_autoscaler_pod_identity]

}