resource "aws_eks_cluster" "eksMainCluster" {
    name     = "mainCluster"
    # version = "1.0"
    role_arn = aws_iam_role.eksServiceRole.arn

    vpc_config {
        subnet_ids = [
            aws_subnet.publicSubnet01.id,
            aws_subnet.publicSubnet02.id,
            aws_subnet.privateSubnet01.id,
            aws_subnet.privateSubnet02.id,
        ]
    }

    # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
    # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
    depends_on = [
        aws_iam_role.eksServiceRole
    ]
}