variable "region" {
  default = "us-east-2"
}

variable "amis" {
  type = map(string)
  default = {
    "us-east-1" = "ami-b374d5a5"
    "us-east-2" = "ami-4b32be2b"
  }
}

variable "vpcBlock" {
    type = string
    default = "192.168.0.0/16"
    description = "The CIDR range for the VPC. This should be a valid private (RFC 1918) CIDR range"

    # Example of validation block in case needed
    validation {
        condition = length(var.vpcBlock) > 4 && substr(var.vpcBlock, 0, 4) == "192."
        error_message = "Any error message ..."
    }
}

variable "publicSubnet01Block" {
    type = string
    default = "192.168.0.0/18"
    description = "CidrBlock for public subnet 01 within the VPC"
}

variable "publicSubnet02Block" {
    type = string
    default = "192.168.64.0/18"
    description = "CidrBlock for public subnet 02 within the VPC"
}

variable "privateSubnet01Block" {
    type = string
    default = "192.168.128.0/18"
    description = "CidrBlock for private subnet 01 within the VPC"
}

variable "privateSubnet02Block" {
    type = string
    default = "192.168.192.0/18"
    description = "CidrBlock for private subnet 02 within the VPC"
}
