# ---------------------------------------------------------------------------------------------------------------------
# Get the Subnets
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "selected" {
  id = module.vpc_subnet.vpc_id
}

data "aws_subnet_ids" "subnet_ids" {
    vpc_id = data.aws_vpc.selected.id
}

module "iam_roles" {
    source = "../modules/eks-iam-policies"
}

module "vpc_subnet" {
    source = "../modules/eks-vpc-subnet"
}

module "eks_cluster" {
    source = "../modules/eks-cluster"
    
    eks_cluster_name = var.cluster_name
    vpc_id = data.aws_vpc.selected.id
    subnet_ids = data.aws_subnet_ids.subnet_ids.ids
    role_arn = module.iam_roles.eks_service_role_arn
}

module "eks_node_group" {
    source = "../modules/eks-node-group"

    cluster_name = module.eks_cluster.eks_cluster_name
    node_group_name = var.node_group_name
    role_arn = module.iam_roles.eks_node_group_service_role_arn
    subnet_ids = data.aws_subnet_ids.subnet_ids.ids
}