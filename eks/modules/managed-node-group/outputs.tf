output "managed_nodegroup_status"  {
    value = aws_eks_node_group.eks_nodegroup[0].status
}

output "managed_nodegroup_arn"  {
    value = aws_eks_node_group.eks_nodegroup[0].arn
}

output "managed_nodegroup_id"  {
    value = aws_eks_node_group.eks_nodegroup[0].id
}