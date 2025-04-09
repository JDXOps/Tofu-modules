data "aws_iam_policy_document" "eks_assume_node_role_policy_document" {
  count = var.enable_bootstrap_nodegroup ? 1 : 0
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
  count              = var.enable_bootstrap_nodegroup ? 1 : 0
  name               = "${var.name}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_node_role_policy_document[0].json
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_pull" {
  role       = aws_iam_role.eks_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_role_policy_attachment" "cni" {
  role       = aws_iam_role.eks_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.eks_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_eks_node_group" "bootstrap_nodegroup" {
  count           = var.enable_bootstrap_nodegroup ? 1 : 0
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "karpenter-bootstrap-${aws_eks_cluster.eks_cluster.name}"
  version         = aws_eks_cluster.eks_cluster.version
  subnet_ids      = var.private_subnet_ids
  node_role_arn   = aws_iam_role.eks_node_role[0].arn

  scaling_config {
    min_size     = 1
    max_size     = 1
    desired_size = 1

  }

  ami_type       = "BOTTLEROCKET_ARM_64"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t4g.small"]


  tags = {
    Name = "karpenter-bootstrap"
  }

  depends_on = [aws_iam_role_policy_attachment.cni, aws_iam_role_policy_attachment.ecr_pull, aws_iam_role_policy_attachment.eks_worker_node_policy, aws_iam_role_policy_attachment.ssm, aws_eks_cluster.eks_cluster]
}