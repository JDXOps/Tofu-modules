resource "aws_eks_addon" "pod_identity_agent" {
  count         = var.enable_pod_identity_agent ? 1 : 9
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = var.pod_identity_agent_version
}