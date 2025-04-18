############################
# Security Module
############################

# EKS Security Group
resource "aws_security_group" "eks_cluster" {
  count       = var.create_eks_security_group ? 1 : 0
  name        = "${var.prefix}-eks-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-eks-cluster-sg"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
  )
}

resource "aws_security_group_rule" "eks_cluster_ingress" {
  count             = var.create_eks_security_group ? 1 : 0
  security_group_id = aws_security_group.eks_cluster[0].id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr]
  description       = "Allow HTTPS traffic to EKS API server"
}

resource "aws_security_group_rule" "eks_cluster_egress" {
  count             = var.create_eks_security_group ? 1 : 0
  security_group_id = aws_security_group.eks_cluster[0].id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

# EKS Node Group Security Group
resource "aws_security_group" "eks_nodes" {
  count       = var.create_eks_security_group ? 1 : 0
  name        = "${var.prefix}-eks-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-eks-nodes-sg"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
  )
}

resource "aws_security_group_rule" "eks_nodes_ingress_self" {
  count             = var.create_eks_security_group ? 1 : 0
  security_group_id = aws_security_group.eks_nodes[0].id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  description       = "Allow all traffic within node group"
}

resource "aws_security_group_rule" "eks_nodes_ingress_cluster" {
  count                    = var.create_eks_security_group ? 1 : 0
  security_group_id        = aws_security_group.eks_nodes[0].id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks_cluster[0].id
  description              = "Allow all traffic from EKS control plane"
}

resource "aws_security_group_rule" "eks_nodes_egress" {
  count             = var.create_eks_security_group ? 1 : 0
  security_group_id = aws_security_group.eks_nodes[0].id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

# RDS Security Group
resource "aws_security_group" "rds" {
  count       = var.create_rds_security_group ? 1 : 0
  name        = "${var.prefix}-rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-rds-sg"
    }
  )
}

resource "aws_security_group_rule" "rds_ingress_eks" {
  count                    = var.create_rds_security_group && var.create_eks_security_group ? 1 : 0
  security_group_id        = aws_security_group.rds[0].id
  type                     = "ingress"
  from_port                = 5432  # Default PostgreSQL port
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_nodes[0].id
  description              = "Allow PostgreSQL traffic from EKS nodes"
}

resource "aws_security_group_rule" "rds_ingress_bastion" {
  count                    = var.create_rds_security_group && var.create_bastion_security_group ? 1 : 0
  security_group_id        = aws_security_group.rds[0].id
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion[0].id
  description              = "Allow PostgreSQL traffic from bastion host"
}

resource "aws_security_group_rule" "rds_egress" {
  count             = var.create_rds_security_group ? 1 : 0
  security_group_id = aws_security_group.rds[0].id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

# Bastion Host Security Group
resource "aws_security_group" "bastion" {
  count       = var.create_bastion_security_group ? 1 : 0
  name        = "${var.prefix}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-bastion-sg"
    }
  )
}

resource "aws_security_group_rule" "bastion_ingress_ssh" {
  count             = var.create_bastion_security_group ? 1 : 0
  security_group_id = aws_security_group.bastion[0].id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.allowed_bastion_cidr_blocks
  description       = "Allow SSH traffic to bastion host"
}

resource "aws_security_group_rule" "bastion_egress" {
  count             = var.create_bastion_security_group ? 1 : 0
  security_group_id = aws_security_group.bastion[0].id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

# Security Group for Vector Database (e.g. OpenSearch)
resource "aws_security_group" "vector_db" {
  name        = "${var.prefix}-vector-db-sg"
  description = "Security group for vector database"
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-vector-db-sg"
    }
  )
}

resource "aws_security_group_rule" "vector_db_ingress_eks" {
  count                    = var.create_eks_security_group ? 1 : 0
  security_group_id        = aws_security_group.vector_db.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_nodes[0].id
  description              = "Allow HTTPS traffic from EKS nodes"
}

resource "aws_security_group_rule" "vector_db_ingress_bastion" {
  count                    = var.create_bastion_security_group ? 1 : 0
  security_group_id        = aws_security_group.vector_db.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion[0].id
  description              = "Allow HTTPS traffic from bastion host"
}

resource "aws_security_group_rule" "vector_db_egress" {
  security_group_id = aws_security_group.vector_db.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all outbound traffic"
}

# Network ACLs
resource "aws_network_acl" "private" {
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-private-nacl"
    }
  )
}

resource "aws_network_acl_rule" "private_ingress" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_egress" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}
