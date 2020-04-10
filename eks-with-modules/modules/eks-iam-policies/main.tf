# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
}

# ----------------------------------------------------------------------------------------------------------------------
# EKS Node Group Service Role
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "eksNodeGroupAssumeRolePolicy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "eks.amazonaws.com",
        "ec2.amazonaws.com"
        ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eksManagedAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eksNodeGroupServiceRole.name
}

resource "aws_iam_role_policy_attachment" "eksManagedAmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eksNodeGroupServiceRole.name
}

resource "aws_iam_role_policy_attachment" "eksManagedAmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eksNodeGroupServiceRole.name
}

# IAM role that Node Group can assume to create AWS resources 
resource "aws_iam_role" "eksNodeGroupServiceRole" {
  name = "eksNodeGroupRole"
  assume_role_policy = data.aws_iam_policy_document.eksNodeGroupAssumeRolePolicy.json
}

# ----------------------------------------------------------------------------------------------------------------------
# EKS Service Role 
# Policy that allow Kubernetes to assume role and then create AWS resources
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "eksAssumeRolePolicy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "eks.amazonaws.com",
        ]
    }
  }
}

# EKS Service managed policy to be attached at eksServiceRole
data "aws_iam_policy" "eksServicePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# EKS Cluster managed policy to be attached at eksServiceRole
data "aws_iam_policy" "eksClusterPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach the EKS Service managed policy to the eksServiceRole
resource "aws_iam_role_policy_attachment" "eksManagedEksServicePolicy" {
  # The role(s) that the policy should be applied to
  role = aws_iam_role.eksServiceRole.name
  policy_arn = data.aws_iam_policy.eksServicePolicy.arn
}

# Attach the EKS Cluster managed policy to the eksServiceRole
resource "aws_iam_role_policy_attachment" "eksManagedEksClusterPolicy" {
  # The role(s) that the policy should be applied to
  role = aws_iam_role.eksServiceRole.name
  policy_arn = data.aws_iam_policy.eksClusterPolicy.arn
}

# IAM role that Kubernetes can assume to create AWS resources 
resource "aws_iam_role" "eksServiceRole" {
  name = "eksRole"
  assume_role_policy = data.aws_iam_policy_document.eksAssumeRolePolicy.json
}
