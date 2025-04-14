variable "name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "cluster_oidc_arn" {
  type        = string
  description = "The ARN of the IRSA OIDC provider."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The private subnet IDs for your EKS cluster to use."
}

variable "enable_karpenter" {
  type        = bool
  description = "Boolean toggle to enable Karpenter nodescaling."
}

variable "karpenter_namespace" {
  type        = string
  description = "The namespace to deploy Karpenter into."
  default     = "karpenter"
}

variable "karpenter_service_account" {
  type        = string
  description = "The Karpenter service account name."
  default     = "karpenter"
}

variable "karpenter_version" {
  type        = string
  description = "The version of the Karpenter Helm Chart to deploy."
}

variable "karpenter_subnet_ids" {
  type        = list(string)
  description = "The IDs of the subnets to use for nodes provisioned by Karpenter."
}

variable "security_group_id" {
  type        = string
  description = "The ID of the security group to use for nodes provisioned by Karpenter"
}