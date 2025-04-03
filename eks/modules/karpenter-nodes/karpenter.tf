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

  depends_on = [aws_eks_fargate_profile.karpenter]

}

# resource "aws_ec2_tag" {
#   resource_id  = 
# }


# resource "kubectl_manifest" "karpenter_node_class" {
#   yaml_body = <<-YAML
#     apiVersion: karpenter.k8s.aws/v1
#     kind: EC2NodeClass
#     metadata:
#       name: default
#     spec:
#       amiSelectorTerms:
#         - alias: al2023@latest
#       role: ${module.karpenter.node_iam_role_name}
#       subnetSelectorTerms:
#         - tags:
#             karpenter.sh/discovery: ${local.env}
#       securityGroupSelectorTerms:
#         - tags:
#             karpenter.sh/discovery: ${module.eks.cluster_name}
#         - id: ${module.eks_community.cluster_primary_security_group_id}
#       tags:
#         karpenter.sh/discovery: ${module.eks.cluster_name}
#   YAML

#   depends_on = [
#     helm_release.karpenter
#   ]
# }


