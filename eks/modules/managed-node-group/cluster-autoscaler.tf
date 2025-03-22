resource "helm_release" "karpenter" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  name       = "cluster-autoscaler"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.cluster_autoscaler_version
  wait       = true

  set = [
    {
      name  = "autoDiscovery.clusterName"
      value = data.aws_eks_cluster.eks_cluster.name
    }
  ]

  depends_on = [aws_eks_node_group.eks_nodegroup]

}