variable "eks_cluster_name" {
  description = ""
  type = string
}

# variable "vpc_id" {
#   description = "The ID of the VPC in which the EKS/NodesGroup will be created."
#   type = string
# }

variable "role_arn" {
    description = ""
    type = string
}

variable "subnet_ids" {
    description = ""
    type = list(string)
}