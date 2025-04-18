terraform {
  backend "s3" {
    # The bucket name, key, region, and dynamodb_table will be provided via -backend-config
    # parameters when running terraform init using the init-terraform.sh script
    encrypt = true
  }
}
