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
        bucket = "aws-eks-terraform-state-wendys-dev"
        key = "global/s3/terraform.tfstate"
        region = "us-east-1"

        # DynamoDB
        dynamodb_table = "terraform-up-and-running-locks-dev"
        encrypt = true
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# Get the Subnets
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "selected" {
  id = module.vpc_subnet.vpc_id
}

data "aws_subnet_ids" "subnet_ids" {
    vpc_id = data.aws_vpc.selected.id
}

module "iam_roles" {
    source = "../modules/eks-iam-policies"
}

module "vpc_subnet" {
    source = "../modules/eks-vpc-subnet"
}

module "eks_cluster" {
    source = "../modules/eks-cluster"
    
    eks_cluster_name = var.cluster_name
    vpc_id = data.aws_vpc.selected.id
    subnet_ids = data.aws_subnet_ids.subnet_ids.ids
    role_arn = module.iam_roles.eks_service_role_arn
}

module "eks_node_group" {
    source = "../modules/eks-node-group"

    cluster_name = module.eks_cluster.eks_cluster_name
    node_group_name = var.node_group_name
    role_arn = module.iam_roles.eks_node_group_service_role_arn
    subnet_ids = data.aws_subnet_ids.subnet_ids.ids
}