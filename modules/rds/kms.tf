data "aws_iam_policy_document" "rds_kms_policy" {
  count = var.create_kms_key ? 1 : 0
  statement {
    sid    = "Allow account to manage key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow RDS to use key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}


resource "aws_kms_key" "kms_key" {
  count       = var.create_kms_key ? 1 : 0
  description = "At rest encryption key for ${var.identifier} RDS instance"
  key_usage   = "ENCRYPT_DECRYPT"
  policy      = data.aws_iam_policy_document.rds_kms_policy.json
}