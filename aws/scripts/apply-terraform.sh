#!/bin/bash
# Script to apply Terraform changes to an environment

set -e

# Default environment
ENV=${1:-dev}
ACTION=${2:-plan}  # Default action is plan, can be apply, destroy, etc.

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

# Navigate to the environment directory
cd "../terraform/environments/${ENV}"

# Ensure Terraform is initialized
if [ ! -d ".terraform" ]; then
    echo "Terraform not initialized. Running init-terraform.sh first..."
    cd "../../../scripts"
    ./init-terraform.sh "${ENV}"
    cd "../terraform/environments/${ENV}"
fi

# Make sure we're in the right workspace
terraform workspace select "${ENV}" || terraform workspace new "${ENV}"

# Run Terraform action
echo "Running terraform ${ACTION} for ${ENV} environment..."

case "${ACTION}" in
    plan)
        terraform plan -out=tfplan
        ;;
    apply)
        # If there's an existing plan, use it, otherwise create a new one
        if [ -f "tfplan" ]; then
            echo "Applying existing plan..."
            terraform apply tfplan
            # Remove the plan file after applying
            rm tfplan
        else
            echo "No existing plan found. Running plan and apply..."
            terraform plan -out=tfplan
            terraform apply tfplan
            # Remove the plan file after applying
            rm tfplan
        fi
        ;;
    destroy)
        echo "Warning: This will destroy all resources in the ${ENV} environment."
        read -p "Are you sure you want to continue? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            terraform destroy -auto-approve
        else
            echo "Destroy cancelled."
            exit 0
        fi
        ;;
    *)
        # For any other action, pass it directly to terraform
        terraform "${ACTION}"
        ;;
esac

echo "Terraform ${ACTION} completed for ${ENV} environment."
