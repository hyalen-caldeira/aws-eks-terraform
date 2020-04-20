# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12"
  experiments = [variable_validation]
}

resource "aws_eks_node_group" "awsEksNodeGroup" {
    cluster_name = var.cluster_name
    node_group_name = var.node_group_name
    node_role_arn   = var.role_arn
    
    subnet_ids = var.subnet_ids

    instance_types = [
        "t2.micro"
    ]

    scaling_config {
        desired_size = 1
        max_size = 1
        min_size = 1
    }

    # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
    # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
    depends_on = [
        var.eks_managed_amazon_eks_worker_node_policy,
        var.eks_managed_amazon_eks_cni_policy,
        var.eks_managed_amazon_ec2_container_registry_read_only,
    ]
}