terraform {
  required_version = "~> 0.12"
  experiments = [variable_validation]
}

provider "aws" {
    version = "~> 2.55"
    profile = "default"
    region = var.region
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

resource "aws_vpc" "eksVpc" {
    cidr_block = var.vpcBlock
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "eksVpc"
        Environment = "development"
    }
}