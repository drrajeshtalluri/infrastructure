############################
# Security Module Outputs
############################

output "eks_cluster_security_group_id" {
  description = "ID of the EKS cluster security group"
  value       = var.create_eks_security_group ? aws_security_group.eks_cluster[0].id : ""
}

output "eks_nodes_security_group_id" {
  description = "ID of the EKS nodes security group"
  value       = var.create_eks_security_group ? aws_security_group.eks_nodes[0].id : ""
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = var.create_rds_security_group ? aws_security_group.rds[0].id : ""
}

output "bastion_security_group_id" {
  description = "ID of the bastion host security group"
  value       = var.create_bastion_security_group ? aws_security_group.bastion[0].id : ""
}

output "vector_db_security_group_id" {
  description = "ID of the vector database security group"
  value       = aws_security_group.vector_db.id
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = aws_network_acl.private.id
}
