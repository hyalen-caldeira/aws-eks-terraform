variable "region" {
  default = "us-east-2"
}

variable "vpc_id" {
  description = "The ID of the VPC in which the EKS/NodesGroup will be created."
  type        = string
  default     = null
}

variable "cluster_name" {
    description = ""
    type = string
    default = "main_cluster"
}

variable "node_group_name" {
    description = ""
    type = string
    default = "aws_eks_main_cluster_node_group"
}