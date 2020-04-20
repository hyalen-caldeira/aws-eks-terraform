output "eks_service_role_arn" {
    value = aws_iam_role.eksServiceRole.arn
    description = ""
}

output "eks_node_group_service_role_arn" {
    value = aws_iam_role.eks_node_group_service_role.arn
    description = ""
}

output "eks_managed_amazon_eks_worker_node_policy" {
    value = aws_iam_role_policy_attachment.eksManagedAmazonEKSWorkerNodePolicy
    description = ""
}

output "eks_managed_amazon_eks_cni_policy" {
    value = aws_iam_role_policy_attachment.eksManagedAmazonEKS_CNI_Policy
    description = ""
}

output "eks_managed_amazon_ec2_container_registry_read_only" {
    value = aws_iam_role_policy_attachment.eksManagedAmazonEC2ContainerRegistryReadOnly
    description = ""
}