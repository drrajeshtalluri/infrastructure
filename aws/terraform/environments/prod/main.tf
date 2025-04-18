############################
# Production Environment
############################

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = "prod"
      Project     = "PolicyAgentModule"
      ManagedBy   = "Terraform"
    }
  }
}

locals {
  prefix = "${var.project_name}-prod"
}

# Networking Module
module "networking" {
  source = "../../modules/networking"

  prefix             = local.prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  region             = var.region
  enable_flow_logs   = true
  
  tags = {
    Environment = "prod"
    Project     = var.project_name
  }
}

# Security Module
module "security" {
  source = "../../modules/security"

  prefix                      = local.prefix
  vpc_id                      = module.networking.vpc_id
  vpc_cidr                    = module.networking.vpc_cidr
  create_eks_security_group   = true
  create_rds_security_group   = true
  create_bastion_security_group = true
  private_subnet_ids          = module.networking.private_subnet_ids
  allowed_bastion_cidr_blocks = var.allowed_bastion_cidr_blocks
  eks_cluster_name            = "${local.prefix}-cluster"
  
  tags = {
    Environment = "prod"
    Project     = var.project_name
  }
}

# IAM Module
module "iam" {
  source = "../../modules/iam"

  prefix                   = local.prefix
  create_eks_service_role  = true
  create_s3_access_role    = true
  create_rds_access_role   = true
  create_vector_db_access_role = true
  eks_cluster_name         = "${local.prefix}-cluster"
  
  tags = {
    Environment = "prod"
    Project     = var.project_name
  }
}
