resource "aws_eks_node_group" "awsEksNodeGroup" {
  count = 1

  cluster_name    = aws_eks_cluster.eksMainCluster.name
  node_group_name = "awsEksNodeGroup"
  node_role_arn   = aws_iam_role.eksNodeGroupServiceRole.arn
  
  subnet_ids      = [
      aws_subnet.publicSubnet01.id,
      aws_subnet.publicSubnet02.id,
      aws_subnet.privateSubnet01.id,
      aws_subnet.privateSubnet02.id
  ]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eksManagedAmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eksManagedAmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eksManagedAmazonEC2ContainerRegistryReadOnly,
  ]
}