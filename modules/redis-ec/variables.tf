variable "subnet_ids" {
  type        = list(string)
  description = "List of Subnet Ids that are for the Redis EC cluster"
}

variable "name" {
  type        = string
  description = "Name of the Elasticache cluster."
}

variable "engine" {
  type        = string
  description = "Name of the cache engine to use for this Elasticache Cluster (Redis, Memcached or Valkey)."
}

variable "engine_version" {
  type        = string
  description = "Version number of the cache engine to be used. Default is the latest version"
}

variable "num_nodes" {
    type = number
    description = "The initial number of cache nodes that are deployed for the Elasticache cluster"
}

variable "apply_immediately" {
    type = bool 
    description = "Toggle to control if modifications to the Elasticache happen immediatley or during the maintenance window"
}

variable "maintenance_window" {
    type = string 
    description = "Specify the weekly time range for when maintenance on the cache cluster is performed"
    default = "sun:05:00-sun:09:00"
}

variable "port" {
    type = number 
    description = "The port number on which each of the cahce nodes will accept connections"
}

variable "tags" {
  type        = map(any)
  description = "Tags to set on the Elasaticache cluster"
}

variable "allowed_ingress_cidrs" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks to allow inbound DB access (empty = no access)."
}
