# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
    required_version = ">= 0.12"
    experiments = [variable_validation]
}

resource "aws_eks_cluster" "eks_main_cluster" {
    name = var.eks_cluster_name
    role_arn = var.role_arn

    vpc_config {
        subnet_ids = var.subnet_ids
    }

    # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
    # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
    depends_on = [
        var.role_arn
        # aws_iam_role.eksServiceRole,
        # aws_vpc.eksVpc
    ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Create your OIDC identity provider for your cluste
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "eks_oidc" {
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = []
    url = aws_eks_cluster.eks_main_cluster.identity.0.oidc.0.issuer
}

data "aws_caller_identity" "current" {}

# ----------------------------------------------------------------------------------------------------------------------
# 
# ----------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "eks_oidc_assume_role_policy" {
    statement {
        actions = ["sts:AssumeRoleWithWebIdentity"]
        effect = "Allow"

        condition {
            test = "StringEquals"
            variable = "${replace(aws_iam_openid_connect_provider.eks_oidc.url, "https://", "")}:sub"
            values = ["system:serviceaccount:kube-system:aws-node"]
        }

        principals {
            identifiers = [aws_iam_openid_connect_provider.eks_oidc.arn]
            type = "Federated"
        }
    }
}

resource "aws_iam_role" "eks_iodc_role" {
    assume_role_policy = data.aws_iam_policy_document.eks_oidc_assume_role_policy.json
    name = "example"
}