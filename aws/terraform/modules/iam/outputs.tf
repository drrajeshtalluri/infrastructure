############################
# IAM Module Outputs
############################

output "eks_service_role_arn" {
  description = "ARN of the EKS service role"
  value       = var.create_eks_service_role ? aws_iam_role.eks_service_role[0].arn : ""
}

output "eks_service_role_name" {
  description = "Name of the EKS service role"
  value       = var.create_eks_service_role ? aws_iam_role.eks_service_role[0].name : ""
}

output "eks_node_role_arn" {
  description = "ARN of the EKS node role"
  value       = var.create_eks_service_role ? aws_iam_role.eks_node_role[0].arn : ""
}

output "eks_node_role_name" {
  description = "Name of the EKS node role"
  value       = var.create_eks_service_role ? aws_iam_role.eks_node_role[0].name : ""
}

output "s3_access_role_arn" {
  description = "ARN of the S3 access role"
  value       = var.create_s3_access_role ? aws_iam_role.s3_access_role[0].arn : ""
}

output "s3_access_role_name" {
  description = "Name of the S3 access role"
  value       = var.create_s3_access_role ? aws_iam_role.s3_access_role[0].name : ""
}

output "rds_access_role_arn" {
  description = "ARN of the RDS access role"
  value       = var.create_rds_access_role ? aws_iam_role.rds_access_role[0].arn : ""
}

output "rds_access_role_name" {
  description = "Name of the RDS access role"
  value       = var.create_rds_access_role ? aws_iam_role.rds_access_role[0].name : ""
}

output "vector_db_access_role_arn" {
  description = "ARN of the vector database access role"
  value       = var.create_vector_db_access_role ? aws_iam_role.vector_db_access_role[0].arn : ""
}

output "vector_db_access_role_name" {
  description = "Name of the vector database access role"
  value       = var.create_vector_db_access_role ? aws_iam_role.vector_db_access_role[0].name : ""
}
