data "aws_iam_policy_document" "eksNodeGroupAssumeRolePolicy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "eks.amazonaws.com",
        "ec2.amazonaws.com"
        ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eksManagedAmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eksNodeGroupServiceRole.name
}

resource "aws_iam_role_policy_attachment" "eksManagedAmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eksNodeGroupServiceRole.name
}

resource "aws_iam_role_policy_attachment" "eksManagedAmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eksNodeGroupServiceRole.name
}

# IAM role that Node Group can assume to create AWS resources 
resource "aws_iam_role" "eksNodeGroupServiceRole" {
  name = "eksNodeGroupRole"
  assume_role_policy = data.aws_iam_policy_document.eksNodeGroupAssumeRolePolicy.json
}

output "eksNodeGroupServiceRoleArn" {
  value = aws_iam_role.eksNodeGroupServiceRole.arn
}