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