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

# provider "aws" {
#     region = var.aws_region

#     # version = "2.31.0"
#     assume_role {
#         role_arn = format("arn:aws:iam::%s:role/WEN-AWS-%s-Instance-JenkinsDeploy-Role", var.aws_account_id, title(var.aws_environment))
#     }
    
#     profile = var.aws_environment
# }

# ---------------------------------------------------------------------------------------------------------------------
# Configure Terraform to store the state in S3 bucket (with encryption and locking)
# ---------------------------------------------------------------------------------------------------------------------

terraform {
    backend "s3" {
        # S3
        bucket = "aws-eks-terraform-up-and-running-state-dev"
        key = "global/s3/terraform.tfstate"
        region = "us-east-2"
        profile = "default"
        shared_credentials_file = "$HOME/.aws/credentials"

        # DynamoDB
        dynamodb_table = "terraform-up-and-running-locks-dev"
        encrypt = true
    }
}

# terraform {
#     backend "consul" {
#         address      = "consul.wendys.com:8501"
#         path         = "terraform/digital-k8s-luis--ENV-/state"
#         scheme       = "https"
#         lock         = "true"
#     }
# }

# data "terraform_remote_state" "eks" {
#     backend = "consul"
#     config =  {
#         address      = "consul.wendys.com:8501"
#         path         = "terraform/aws-eks-cluster--ENV-/state"
#         scheme       = "https"
#         lock         = "true"
#     }
# }

# output aws_account_id {
#     value = var.aws_account_id
# }
