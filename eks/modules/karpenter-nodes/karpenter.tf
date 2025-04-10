# Karpenter Deplyment
resource "helm_release" "karpenter" {
  count            = var.enable_karpenter ? 1 : 0
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  namespace        = var.karpenter_namespace
  create_namespace = true
  chart            = "karpenter"
  version          = var.karpenter_version

  set = [
    {
      name  = "settings.clusterName"
      value = data.aws_eks_cluster.eks_cluster[0].name
    },
    {
      name  = "settings.clusterEndpoint"
      value = data.aws_eks_cluster.eks_cluster[0].endpoint
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.karpenter[0].arn
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = var.karpenter_service_account
    }
  ]
  depends_on = [aws_eks_pod_identity_association.karpenter]
}

