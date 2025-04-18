############################
# Development Environment Variables
############################

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "policy-agent"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "allowed_bastion_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Change this to your specific IPs in production
}

variable "enable_flow_logs" {
  description = "Enable VPC flow logs"
  type        = bool
  default     = true
}

variable "flow_logs_retention_days" {
  description = "Number of days to retain VPC flow logs"
  type        = number
  default     = 7
}

variable "eks_node_instance_types" {
  description = "Instance types for EKS node groups"
  type        = map(list(string))
  default = {
    system = ["t3.medium"]
    application = ["t3.large"]
    processing = ["t3.xlarge"]
  }
}

variable "eks_desired_capacity" {
  description = "Desired number of nodes in EKS node groups"
  type        = map(number)
  default = {
    system = 2
    application = 2
    processing = 1
  }
}

variable "eks_min_size" {
  description = "Minimum number of nodes in EKS node groups"
  type        = map(number)
  default = {
    system = 1
    application = 1
    processing = 0
  }
}

variable "eks_max_size" {
  description = "Maximum number of nodes in EKS node groups"
  type        = map(number)
  default = {
    system = 3
    application = 4
    processing = 2
  }
}

variable "rds_instance_class" {
  description = "Instance class for RDS database"
  type        = string
  default     = "db.t3.medium"
}

variable "rds_allocated_storage" {
  description = "Allocated storage for RDS database in GB"
  type        = number
  default     = 20
}

variable "rds_engine" {
  description = "Database engine for RDS"
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "Database engine version for RDS"
  type        = string
  default     = "14.5"
}

variable "vector_db_instance_type" {
  description = "Instance type for vector database"
  type        = string
  default     = "t3.medium.search"
}

variable "vector_db_instance_count" {
  description = "Number of instances for vector database"
  type        = number
  default     = 2
}
