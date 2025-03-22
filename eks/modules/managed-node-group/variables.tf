variable "enable_managed_nodegroup" {
  description = "Boolean toggle to enable the default managed nodegroup."
  type        = bool
  default     = true
}

variable "name" {
  type        = string
  description = "The name of the EKS cluster."
}

variable "default_node_group_min_size" {
  type        = number
  description = "The minimum number of nodes in the default nodegroup"
}

variable "default_node_group_max_size" {
  type        = number
  description = "The minimum number of nodes in the default nodegroup"
}

variable "default_node_group_desired_size" {
  type        = number
  description = "The minimum number of nodes in the default nodegroup"
}

variable "default_node_group_capacity_type" {
  type        = string
  description = "Type of capacity associated with the default EKS nodegroup"
}

variable "default_node_group_instance_types" {
  type        = list(string)
  description = "List of instance types associated with the default nodegroup"
}

variable "default_node_group_ami_type" {
  type        = string
  description = "The type of AMI associated with the default nodegroup"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "The private subnet IDs for your EKS cluster to use."
}