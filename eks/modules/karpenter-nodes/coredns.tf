resource "aws_eks_addon" "coredns" {
  count         = 0
  cluster_name  = data.aws_eks_cluster.eks_cluster[0].name
  addon_name    = "coredns"
  addon_version = "v1.11.4-eksbuild.2"

}