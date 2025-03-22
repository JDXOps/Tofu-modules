data "tls_certificate" "default" {
  count = var.enable_irsa ? 1 : 0
  url   = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_irsa" {
  count           = var.enable_irsa ? 1 : 0
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.default[0].certificates[0].sha1_fingerprint]
}
