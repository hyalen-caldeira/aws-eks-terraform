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

variable "eks_managed_amazon_eks_worker_node_policy" {
    description = ""
    type = object ({
        id = string
        policy_arn = string
        role = string
    })
}

variable "eks_managed_amazon_eks_cni_policy" {
    description = ""
    type = object ({
        id = string
        policy_arn = string
        role = string
    })
}

variable "eks_managed_amazon_ec2_container_registry_read_only" {
    description = ""
    type = object ({
        id = string
        policy_arn = string
        role = string
    })
}