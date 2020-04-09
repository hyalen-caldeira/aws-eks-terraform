# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

# ---------------------------------------------------------------------------------------------------------------------
# Get the VPC and Subnets
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "aws_eks_vpc" {
    id = var.vpc_id != null ? var.vpc_id : module.aws_eks_vpc_subnet.vpc_id
}

data "aws_subnet_ids" "aws_eks_subnet_ids" {
  vpc_id = data.aws_vpc.aws_eks_vpc.id
}

module "iam_roles" {
    source = "./modules/eks-iam-policies"
}

module "aws_eks_vpc_subnet" {
    source = "./modules/eks-vpc-subnet"
    should_be_created = false
    # # Colocar count = 0 no modulo para evitar de criar o VPC
    # count = vpc.id ? false : true
    # another key = another value
    # role = module.iam_roles
}

# module "eks cluster" {
#     vpc id = var.vpc.id == null ? module.vpc.vpc.id : vpc.id
#     role = module.iamRoles.id
# }

# module "eks node group" {

# }