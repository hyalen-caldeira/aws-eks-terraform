# ------- VPC & Subnet
output "awsEksVPC-id" {
    value = aws_vpc.eksVpc.id
    description = ""
}

output "awsEksVPCSubnet-ids" {
    value = join(
        ", ", 
        [aws_subnet.publicSubnet01.id, 
        aws_subnet.publicSubnet02.id, 
        aws_subnet.privateSubnet01.id,
        aws_subnet.privateSubnet02.id
    ])
    description = ""
}

output "awsEksVPCSecurityGroup-arn" {
    value = aws_security_group.allow_tls.arn
    description = ""
}

# ------- Service Role 
output "eksServiceRoleArn" {
  value = aws_iam_role.eksServiceRole.arn
  description = ""
}

# ------- Node Group Service Role
output "eksNodeGroupServiceRoleArn" {
  value = aws_iam_role.eksNodeGroupServiceRole.arn
  description = ""
}