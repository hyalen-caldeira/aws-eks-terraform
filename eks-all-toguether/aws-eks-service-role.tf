# Policy that allow Kubernetes to assume role and then create AWS resources
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
  role       = aws_iam_role.eksServiceRole.name
  policy_arn = data.aws_iam_policy.eksServicePolicy.arn
}

# Attach the EKS Cluster managed policy to the eksServiceRole
resource "aws_iam_role_policy_attachment" "eksManagedEksClusterPolicy" {
  # The role(s) that the policy should be applied to
  role       = aws_iam_role.eksServiceRole.name
  policy_arn = data.aws_iam_policy.eksClusterPolicy.arn
}

# IAM role that Kubernetes can assume to create AWS resources 
resource "aws_iam_role" "eksServiceRole" {
  name = "eksRole"
  assume_role_policy = data.aws_iam_policy_document.eksAssumeRolePolicy.json
}

# output "eksServiceRoleArn" {
#   value = aws_iam_role.eksServiceRole.arn
#   description = ""
# }