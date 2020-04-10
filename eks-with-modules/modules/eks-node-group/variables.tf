variable "cluster_name" {
    description = ""
    type = string
    default = "aws_eks_cluster"
}

variable "node_group_name" {
    description = ""
    type = string
    default = "aws_eks_node_group"
}

variable "role_arn" {
    description = ""
    type = string
}

variable "subnet_ids" {
    description = ""
    type = list(string)
}

