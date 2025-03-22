data "aws_iam_policy_document" "eks_assume_node_role_policy_document" {
  count = var.enable_managed_nodegroup ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_node_role" {
  count               = var.enable_managed_nodegroup ? 1 : 0
  name                = "${var.name}-eks-node-role"
  assume_role_policy  = data.aws_iam_policy_document.eks_assume_node_role_policy_document[0].json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
}

resource "aws_eks_node_group" "eks_nodegroup" {
  count           = var.enable_managed_nodegroup ? 1 : 0
  cluster_name    = data.aws_eks_cluster.eks_cluster.name
  node_group_name = "default"
  version         = data.aws_eks_cluster.eks_cluster.version
  subnet_ids      = var.private_subnet_ids
  node_role_arn   = aws_iam_role.eks_node_role[0].arn

  scaling_config {
    min_size     = var.default_node_group_min_size
    max_size     = var.default_node_group_max_size
    desired_size = var.default_node_group_desired_size

  }

  ami_type       = var.default_node_group_ami_type
  capacity_type  = var.default_node_group_capacity_type
  instance_types = var.default_node_group_instance_types

  tags = {
    "k8s.io/cluster-autoscaler/enabled"                                = true
    "k8s.io/cluster-autoscaler/${data.aws_eks_cluster.eks_cluster.id}" = "owned"
  }
}