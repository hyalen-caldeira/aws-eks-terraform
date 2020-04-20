output "eks_cluster_name" {
    value = aws_eks_cluster.eks_main_cluster.name
    description = ""
}

output "eks_cluster_endpoint" {
    value = aws_eks_cluster.eks_main_cluster.endpoint
    description = ""
}

output "certificate_authority" {
    value = aws_eks_cluster.eks_main_cluster.certificate_authority.0.data
    description = ""
}