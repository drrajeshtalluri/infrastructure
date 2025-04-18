############################
# IAM Module
############################

# EKS Service Role
resource "aws_iam_role" "eks_service_role" {
  count = var.create_eks_service_role ? 1 : 0
  name  = "${var.prefix}-eks-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-eks-service-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  count      = var.create_eks_service_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_service_role[0].name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  count      = var.create_eks_service_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_service_role[0].name
}

# EKS Node Role
resource "aws_iam_role" "eks_node_role" {
  count = var.create_eks_service_role ? 1 : 0
  name  = "${var.prefix}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-eks-node-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  count      = var.create_eks_service_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role[0].name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  count      = var.create_eks_service_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role[0].name
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_read_only" {
  count      = var.create_eks_service_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role[0].name
}

# S3 Access Role
resource "aws_iam_role" "s3_access_role" {
  count = var.create_s3_access_role ? 1 : 0
  name  = "${var.prefix}-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.create_eks_service_role ? aws_iam_role.eks_node_role[0].arn : ""
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-s3-access-role"
    }
  )
}

resource "aws_iam_policy" "s3_access_policy" {
  count       = var.create_s3_access_role && length(var.s3_bucket_arns) > 0 ? 1 : 0
  name        = "${var.prefix}-s3-access-policy"
  description = "Policy for accessing S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = concat(var.s3_bucket_arns, [for arn in var.s3_bucket_arns : "${arn}/*"])
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  count      = var.create_s3_access_role && length(var.s3_bucket_arns) > 0 ? 1 : 0
  policy_arn = aws_iam_policy.s3_access_policy[0].arn
  role       = aws_iam_role.s3_access_role[0].name
}

# RDS Access Role
resource "aws_iam_role" "rds_access_role" {
  count = var.create_rds_access_role ? 1 : 0
  name  = "${var.prefix}-rds-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.create_eks_service_role ? aws_iam_role.eks_node_role[0].arn : ""
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-rds-access-role"
    }
  )
}

resource "aws_iam_policy" "rds_access_policy" {
  count       = var.create_rds_access_role && length(var.rds_resource_ids) > 0 ? 1 : 0
  name        = "${var.prefix}-rds-access-policy"
  description = "Policy for accessing RDS instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds:DescribeDBClusterParameters",
          "rds:DescribeDBParameters"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "rds-db:connect"
        ]
        Effect   = "Allow"
        Resource = [for id in var.rds_resource_ids : "arn:aws:rds-db:*:*:dbuser:${id}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_access_policy_attachment" {
  count      = var.create_rds_access_role && length(var.rds_resource_ids) > 0 ? 1 : 0
  policy_arn = aws_iam_policy.rds_access_policy[0].arn
  role       = aws_iam_role.rds_access_role[0].name
}

# Vector DB Access Role
resource "aws_iam_role" "vector_db_access_role" {
  count = var.create_vector_db_access_role ? 1 : 0
  name  = "${var.prefix}-vector-db-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.create_eks_service_role ? aws_iam_role.eks_node_role[0].arn : ""
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-vector-db-access-role"
    }
  )
}

resource "aws_iam_policy" "vector_db_access_policy" {
  count       = var.create_vector_db_access_role && length(var.vector_db_resource_arns) > 0 ? 1 : 0
  name        = "${var.prefix}-vector-db-access-policy"
  description = "Policy for accessing vector database"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "es:ESHttpGet",
          "es:ESHttpPut",
          "es:ESHttpPost",
          "es:ESHttpDelete"
        ]
        Effect   = "Allow"
        Resource = var.vector_db_resource_arns
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vector_db_access_policy_attachment" {
  count      = var.create_vector_db_access_role && length(var.vector_db_resource_arns) > 0 ? 1 : 0
  policy_arn = aws_iam_policy.vector_db_access_policy[0].arn
  role       = aws_iam_role.vector_db_access_role[0].name
}
