variable "vpc_id" {
  description = "The ID of the VPC in which the EKS/NodesGroup will be created. Create a new VPC if not supplied."
  type        = string
  default     = null
}