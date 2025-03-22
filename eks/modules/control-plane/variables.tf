variable "name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "cluster_version" {
  type        = string
  description = "The EKS cluster version."
}

variable "enable_endpoint_private_access" {
  type        = bool
  description = "Boolean toggle to enable the EKS Private API server endpoint."
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  description = "Boolean toggle to enable the EKS Private API server endpoint."
}

variable "public_access_cidrs" {
  description = "The CIDR to use for the AWS VPC."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


variable "public_subnet_ids" {
  type        = list(string)
  description = "The public subnet IDs for your EKS cluster to use."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The private subnet IDs for your EKS cluster to use."
}

variable "authentication_mode" {
  description = "The authentication mode to use to grant cluster users access. Valid values are 'API' or 'API_AND_CONFIG_MAP'."
  type        = string
}

variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Boolean toggle to set whether or not the cluster creator IAM principle has cluster admin permissions"
  type        = string
}