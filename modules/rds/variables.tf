variable "identifier" {
  type        = string
  description = "The name of the RDS instance."
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in GB."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of Subnet Ids that are for the RDS instance in a VPC."

}

variable "max_allocated_storage" {
  type        = number
  description = "Max Storage in GB the RDS instance is allowed to scale to."
}

variable "enable_deletion_protection" {
  type        = bool
  description = "The database can't be deleted if this value is set to true"
  default     = true
}

variable "engine" {
  type        = string
  description = "The database engine to use for this DB instance."
}

variable "engine_version" {
  type        = string
  description = "The engine version to use."
}

variable "instance_class" {
  type        = string
  description = "The instance type of the RDS instance."
}

variable "enable_multi_az" {
  type        = bool
  description = "Specifies if the RDS instance is multi az."
}

variable "master_user_username" {
  type        = string
  description = "The username for the master db user."
}

variable "master_user_password" {
  type        = string
  description = "The password for the master db user."
}

variable "port" {
  type        = number
  description = "The port the DB accepts connections on."
}

variable "option_group_name" {
  type        = string
  description = "The name of the DB option group"
  default     = null
}

variable "parameter_group_name" {
  type        = string
  description = "The name of the DB parameter group"
  default     = null
}

variable "tags" {
  type        = map(any)
  description = "The password for the master db user."
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Boolean toggle to skip final snapshot on RDS deletion"
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "Set retention period for daily RDS snapshots"
  default     = 7
}

variable "backup_window" {
  type        = string
  description = "Daily time range (UTC) at which backups are created."
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  type        = string
  description = "Time range (UTC) at which maintenance operations are performed."
  default     = "sun:05:00-sun:06:00"
}


variable "create_kms_key" {
  type        = bool
  description = "Create KMS key for encrypting RDS instance data"
  default     = false
}


variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key to use for at rest encryption.  Set if var.create_kms_key is false"
  default     = null
}

variable "enable_at_rest_encryption" {
  type        = bool
  description = "Enable at rest encryption of data within RDS instance"
  default     = true
}