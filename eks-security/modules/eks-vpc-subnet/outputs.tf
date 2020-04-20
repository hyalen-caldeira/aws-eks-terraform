output "vpc_id" {
    description = ""
    value = aws_vpc.eksVpc.id
}

output "awsEksVPCSubnet-ids" {
    description = ""
    value = join(
        ", ", 
        [aws_subnet.publicSubnet01.id, 
        aws_subnet.publicSubnet02.id, 
        aws_subnet.privateSubnet01.id,
        aws_subnet.privateSubnet02.id
    ])
}

output "aws_eks_vpc_security_group_arn" {
    description = ""
    value = aws_security_group.allow_tls.arn
}