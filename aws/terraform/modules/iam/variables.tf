############################
# IAM Module Variables
############################

variable "prefix" {
  description = "Prefix to be used for all resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "create_eks_service_role" {
  description = "Whether to create the EKS service role"
  type        = bool
  default     = true
}

variable "create_s3_access_role" {
  description = "Whether to create the S3 access role"
  type        = bool
  default     = true
}

variable "create_rds_access_role" {
  description = "Whether to create the RDS access role"
  type        = bool
  default     = true
}

variable "create_vector_db_access_role" {
  description = "Whether to create the vector database access role"
  type        = bool
  default     = true
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "s3_bucket_arns" {
  description = "List of S3 bucket ARNs to allow access to"
  type        = list(string)
  default     = []
}

variable "rds_resource_ids" {
  description = "List of RDS resource IDs to allow access to"
  type        = list(string)
  default     = []
}

variable "vector_db_resource_arns" {
  description = "List of vector database resource ARNs to allow access to"
  type        = list(string)
  default     = []
}
