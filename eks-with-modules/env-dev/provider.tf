# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
    required_version = ">= 0.12"
    experiments = [variable_validation]
}

provider "aws" {
    version = "~> 2.55"
    profile = "default"
    region = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# Configure Terraform to store the state in S3 bucket (with encryption and locking)
# ---------------------------------------------------------------------------------------------------------------------

terraform {
    backend "s3" {
        # S3
        # bucket = "aws-eks-terraform-up-and-running-state-dev"
        bucket = "aws-eks-terraform-up-and-running-state-wendys-dev"
        key = "global/s3/terraform.tfstate"
        region = "us-east-2"

        # DynamoDB
        dynamodb_table = "terraform-up-and-running-locks-dev"
        encrypt = true
    }
}