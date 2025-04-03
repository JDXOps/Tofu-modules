resource "aws_iam_instance_profile" "karpenter" {
  count = var.enable_karpenter ? 1 : 0
  role  = aws_iam_role.eks_node[0].name
  name  = "${data.aws_eks_cluster.eks_cluster[0].name}-karpenter-instance-profile"
}


data "aws_iam_policy_document" "eks_node" {
  count = var.enable_karpenter ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_node" {
  count              = var.enable_karpenter ? 1 : 0
  description        = "IAM Role for Karpenter's InstanceProfile to use when launching nodes"
  assume_role_policy = data.aws_iam_policy_document.eks_node[0].json ##FIX
  name               = "${data.aws_eks_cluster.eks_cluster[0].name}-karpenter-node"

}


resource "aws_iam_role_policy_attachment" "eks_node_attach_AmazonEKSWorkerNodePolicy" {
  count      = var.enable_karpenter ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node[0].name

}


resource "aws_iam_role_policy_attachment" "eks_node_attach_AmazonEC2ContainerRegistryReadOnly" {
  count      = var.enable_karpenter ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node[0].name

}


resource "aws_iam_role_policy_attachment" "eks_node_attach_AmazonEKS_CNI_Policy" {
  count      = var.enable_karpenter ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node[0].name

}


resource "aws_iam_role_policy_attachment" "eks_node_attach_AmazonSSMManagedInstanceCore" {
  count      = var.enable_karpenter ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node[0].name

}

