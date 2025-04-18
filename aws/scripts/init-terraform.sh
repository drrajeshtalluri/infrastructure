#!/bin/bash
# Script to initialize Terraform backend and workspace

set -e

# Default environment
ENV=${1:-dev}

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform is not installed. Please install it first."
    exit 1
fi

# Check if environment directory exists
if [ ! -d "../terraform/environments/${ENV}" ]; then
    echo "Error: Environment '${ENV}' does not exist."
    exit 1
fi

echo "Initializing Terraform for ${ENV} environment..."

# Create S3 bucket for Terraform state if it doesn't exist
BUCKET_NAME="claimsage-terraform-state-${ENV}"
REGION="us-east-1"  # Change as needed

# Check if bucket exists
if ! aws s3api head-bucket --bucket "${BUCKET_NAME}" 2>/dev/null; then
    echo "Creating S3 bucket for Terraform state: ${BUCKET_NAME}"
    aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${REGION}"
    
    # Enable versioning on the bucket
    aws s3api put-bucket-versioning --bucket "${BUCKET_NAME}" --versioning-configuration Status=Enabled
    
    # Enable encryption on the bucket
    aws s3api put-bucket-encryption --bucket "${BUCKET_NAME}" --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'
    
    # Block public access
    aws s3api put-public-access-block --bucket "${BUCKET_NAME}" --public-access-block-configuration '{
        "BlockPublicAcls": true,
        "IgnorePublicAcls": true,
        "BlockPublicPolicy": true,
        "RestrictPublicBuckets": true
    }'
fi

# Create DynamoDB table for state locking if it doesn't exist
TABLE_NAME="claimsage-terraform-locks-${ENV}"

# Check if table exists
if ! aws dynamodb describe-table --table-name "${TABLE_NAME}" 2>/dev/null; then
    echo "Creating DynamoDB table for state locking: ${TABLE_NAME}"
    aws dynamodb create-table \
        --table-name "${TABLE_NAME}" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region "${REGION}"
fi

# Navigate to the environment directory
cd "../terraform/environments/${ENV}"

# Initialize Terraform
echo "Running terraform init..."
terraform init \
    -backend-config="bucket=${BUCKET_NAME}" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="region=${REGION}" \
    -backend-config="dynamodb_table=${TABLE_NAME}" \
    -backend-config="encrypt=true"

# Select or create workspace
echo "Selecting workspace ${ENV}..."
if ! terraform workspace select "${ENV}" 2>/dev/null; then
    echo "Creating workspace ${ENV}..."
    terraform workspace new "${ENV}"
fi

echo "Terraform initialization complete for ${ENV} environment."
