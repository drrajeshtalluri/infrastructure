############################
# Production Environment Outputs
############################

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.networking.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.networking.private_subnet_ids
}

output "database_subnet_ids" {
  description = "IDs of the database subnets"
  value       = module.networking.database_subnet_ids
}

# Security Group Outputs
output "eks_cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = module.security.eks_cluster_security_group_id
}

output "eks_nodes_security_group_id" {
  description = "ID of the EKS nodes security group"
  value       = module.security.eks_nodes_security_group_id
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = module.security.rds_security_group_id
}

output "bastion_security_group_id" {
  description = "ID of the bastion security group"
  value       = module.security.bastion_security_group_id
}

output "vector_db_security_group_id" {
  description = "ID of the vector database security group"
  value       = module.security.vector_db_security_group_id
}

# IAM Role Outputs
output "eks_service_role_arn" {
  description = "ARN of the EKS service role"
  value       = module.iam.eks_service_role_arn
}

output "eks_node_role_arn" {
  description = "ARN of the EKS node role"
  value       = module.iam.eks_node_role_arn
}

output "s3_access_role_arn" {
  description = "ARN of the S3 access role"
  value       = module.iam.s3_access_role_arn
}

output "rds_access_role_arn" {
  description = "ARN of the RDS access role"
  value       = module.iam.rds_access_role_arn
}

output "vector_db_access_role_arn" {
  description = "ARN of the vector database access role"
  value       = module.iam.vector_db_access_role_arn
}
