output "eksServiceRoleArn" {
    value = aws_iam_role.eksServiceRole.arn
    description = ""
}

output "eksNodeGroupServiceRoleArn" {
    value = aws_iam_role.eksNodeGroupServiceRole.arn
    description = ""
}