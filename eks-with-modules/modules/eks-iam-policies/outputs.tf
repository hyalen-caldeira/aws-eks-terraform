output "eks_service_role_arn" {
    value = aws_iam_role.eksServiceRole.arn
    description = ""
}

output "eks_node_group_service_role_arn" {
    value = aws_iam_role.eksNodeGroupServiceRole.arn
    description = ""
}