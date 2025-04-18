############################
# Development Environment Terraform Variables
############################

region = "us-east-1"
project_name = "policy-agent"
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Restrict bastion access in production
allowed_bastion_cidr_blocks = ["0.0.0.0/0"]

enable_flow_logs = true
flow_logs_retention_days = 7

# EKS node groups 
eks_node_instance_types = {
  system = ["t3.medium"]
  application = ["t3.large"]
  processing = ["t3.xlarge"]
}

eks_desired_capacity = {
  system = 2
  application = 2
  processing = 1
}

eks_min_size = {
  system = 1
  application = 1
  processing = 0
}

eks_max_size = {
  system = 3
  application = 4
  processing = 2
}

# RDS settings
rds_instance_class = "db.t3.medium"
rds_allocated_storage = 20
rds_engine = "postgres"
rds_engine_version = "14.5"

# Vector DB settings
vector_db_instance_type = "t3.medium.search"
vector_db_instance_count = 2
