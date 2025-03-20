variable "region" {
  description = "The AWS region to deploy resources into."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR to use for the AWS VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs to use in the AWS VPC"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Public subnet CIDRs to use in the AWS VPC"
  type        = list(string)
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  type        = bool
}

variable "enable_ha_ngw" {
  description = "A boolean flag to enable/disable a high availability setting for the NAT Gateway."
  type        = bool
}

variable "enable_managed_nodegroup" {
  description = "Boolean toggle to enable the default managed nodegroup."
  type = bool
  default = true 
}

variable "enable_karpenter_fargate" {
  description = "Boolean toggle to enable the EKS Fargate for the Karpenter namespace."
  type = bool
  default = false 
}