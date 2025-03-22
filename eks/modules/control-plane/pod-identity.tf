resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name  = aws_eks_cluster.eks_cluster.name
  addon_name    = "eks-pod-identity-agent"
  addon_version = var.pod_identity_agent_version
}