resource "aws_sqs_queue" "karpenter" {
  count                     = var.enable_karpenter ? 1 : 0
  message_retention_seconds = 300
  name                      = "${data.aws_eks_cluster.eks_cluster[0].name}-karpenter"
}


#
# Node termination queue policy
#

resource "aws_sqs_queue_policy" "karpenter" {
  count     = var.enable_karpenter ? 1 : 0
  policy    = data.aws_iam_policy_document.node_termination_queue[0].json
  queue_url = aws_sqs_queue.karpenter[0].url

}


data "aws_iam_policy_document" "node_termination_queue" {
  count = var.enable_karpenter ? 1 : 0
  statement {
    resources = [aws_sqs_queue.karpenter[0].arn]
    sid       = "SQSWrite"
    actions   = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]

    }

  }

}
