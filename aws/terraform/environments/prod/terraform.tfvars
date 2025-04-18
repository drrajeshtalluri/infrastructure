############################
# Production Environment Terraform Variables
############################

region = "us-east-1"
project_name = "policy-agent"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Restrict bastion access to specific IPs in production
allowed_bastion_cidr_blocks = [
  # Add specific allowed IP ranges for production
  # Example: "203.0.113.0/24", # Office IP range
]

enable_flow_logs = true
flow_logs_retention_days = 30

# EKS node groups with production-grade instances
eks_node_instance_types = {
  system = ["t3.medium"]
  application = ["m5.large"]
  processing = ["c5.xlarge"]
}

eks_desired_capacity = {
  system = 3
  application = 4
  processing = 2
}

eks_min_size = {
  system = 2
  application = 2
  processing = 1
}

eks_max_size = {
  system = 5
  application = 8
  processing = 4
}

# RDS settings for production
rds_instance_class = "db.m5.large"
rds_allocated_storage = 50
rds_engine = "postgres"
rds_engine_version = "14.5"

# Vector DB settings for production
vector_db_instance_type = "m5.large.search"
vector_db_instance_count = 3
