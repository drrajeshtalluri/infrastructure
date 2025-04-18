############################
# Security Module Variables
############################

variable "prefix" {
  description = "Prefix to be used for all resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "create_eks_security_group" {
  description = "Whether to create the EKS security group"
  type        = bool
  default     = true
}

variable "create_rds_security_group" {
  description = "Whether to create the RDS security group"
  type        = bool
  default     = true
}

variable "create_bastion_security_group" {
  description = "Whether to create the bastion security group"
  type        = bool
  default     = true
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}

variable "allowed_bastion_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Not recommended for production
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}
