variable "region" {
  default = "us-east-2"
}

variable "vpc_id" {
  description = "The ID of the VPC in which the EKS/NodesGroup will be created."
  type        = string
  default     = null
}